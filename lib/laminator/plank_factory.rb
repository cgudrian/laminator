module Laminator
  class PlankFactory
    attr_reader :plank_count

    def initialize(plank_format:)
      @plank_count = 0
      @plank_width = plank_format.width
      @plank_length = plank_format.length
    end

    def new_plank
      @plank_count += 1
      Plank.new(number: @plank_count, width: @plank_width, length: @plank_length)
    end
  end
end