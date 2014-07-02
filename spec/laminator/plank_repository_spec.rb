require 'spec_helper'

describe Laminator::PlankRepository do

  let(:factory) { Laminator::PlankFactory.new(plank_width: 100, plank_length: 500) }
  let(:repository) { Laminator::PlankRepository.new(factory: factory, kerf: 7) }

  context '#get_plank' do
    context 'when empty' do
      context 'and the requested length is greater than the plank length' do
        it 'gets a new, uncut plank from the factory' do
          plank = repository.get_plank(length: 1000)
          expect(plank.number).to eq(1)
          expect(plank.length).to eq(500)
          expect(plank.cuts).to be_empty
        end
      end

      context 'and the requested length is smaller than the plank length' do
        let!(:plank) { repository.get_plank(length: 350, side: :right) }

        it 'gets a new plank from the repository cut to the correct size' do
          expect(plank.length).to eq(350)
          expect(plank.cuts).to eq(Set.new([:right]))
          expect(plank.number).to eq(1)
        end

        it 'saves the remaining part for later reuse' do
          expect(repository.planks.count).to eq(1)
          plank = repository.planks.first
          expect(plank.length).to eq(143)
          expect(plank.cuts).to eq(Set.new([:left]))
        end
      end
    end


    context 'when not empty' do
      before(:each) do
        repository.put_plank(Laminator::Plank.new(number: 1, length: 300, width: 100, cuts: Set.new([:right])))
        repository.put_plank(Laminator::Plank.new(number: 2, length: 100, width: 100, cuts: Set.new([:right])))
        repository.put_plank(Laminator::Plank.new(number: 3, length: 200, width: 100, cuts: Set.new([:left])))
      end

      it 'yields the smallest possible plank cut to the desired length' do
        plank = repository.get_plank(length: 190, side: :left)
        expect(plank.number).to eq(3)
        expect(plank.length).to eq(190)

        plank = repository.get_plank(length: 150, side: :right)
        expect(plank.number).to eq(1)
        expect(plank.length).to eq(150)

        plank = repository.get_plank(length: 80, side: :right)
        expect(plank.number).to eq(2)
        expect(plank.length).to eq(80)
      end
    end
  end
end