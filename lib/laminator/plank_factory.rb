module Laminator
  class PlankFactory
    attr_reader :plank_count

    def initialize(plank_size:)
      @plank_count = 0
      @plank_size = plank_size
    end

    def new_plank
      @plank_count += 1
      Plank.new(number: @plank_count, size: @plank_size)
    end
  end
end