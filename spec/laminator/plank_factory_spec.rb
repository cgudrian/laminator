require 'spec_helper'

describe Laminator::PlankFactory do

  let(:factory) { Laminator::PlankFactory.new(plank_length: 50, plank_width: 100) }

  it 'creates a planks of the specified size' do
    plank = factory.new_plank
    expect(plank.length).to eq(50)
    expect(plank.width).to eq(100)
  end

  it 'increments the plank counter with each new plank' do
    expect(factory.plank_count).to eq(0)
    factory.new_plank
    factory.new_plank
    expect(factory.plank_count).to eq(2)
  end
end