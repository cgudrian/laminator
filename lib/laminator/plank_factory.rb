module Laminator
  class PlankFactory
    attr_reader :plank_count
    attr_reader :plank_width
    attr_reader :plank_length

    def initialize(plank_length:, plank_width:)
      @plank_count = 0
      @plank_length = plank_length
      @plank_width = plank_width
    end

    def new_plank
      @plank_count += 1
      Plank.new(number: @plank_count, length: @plank_length, width: @plank_width)
    end
  end
end