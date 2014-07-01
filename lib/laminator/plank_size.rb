module Laminator
  class PlankSize
  attr_reader :width
    attr_reader :length

    def initialize(width:, length:)
      @width = width
      @length = length
    end
  end
end
