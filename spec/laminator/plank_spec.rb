require 'spec_helper'

describe Laminator::Plank do

  let(:plank) { Laminator::Plank.new(number: 42, length: 4711, width: 815) }
  let(:cut_plank) { plank.make_cut(length: 1000, side: :right, kerf: 7) }

  context '#make_cut' do
    it 'leaves two shorters planks' do
      expect(cut_plank.length).to eq(3704)
      expect(plank.length).to eq(1000)
    end

    it 'leaves two planks with the same number' do
      expect(cut_plank.number).to eq(42)
      expect(plank.number).to eq(42)
    end

    it 'leaves two planks cut on opposite sides' do
      expect(cut_plank.cuts).to match_array([:left])
      expect(plank.cuts).to match_array([:right])
    end

    context 'when called again on the oppsite side' do
      it 'yields one plank with cuts on both sides and one with a cut on one side' do
        plank = cut_plank.make_cut(length: 500, side: :right)
        expect(cut_plank.cuts).to match_array([:right, :left])
        expect(plank.cuts).to match_array([:left])
      end
    end
  end

end