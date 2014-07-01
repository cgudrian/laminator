module Laminator
  class Plank
    attr_reader :number
    attr_reader :width
    attr_reader :length
    attr_reader :cut

    def initialize(number:, width:, length:, cut: :none)
      @number = number
      @width = Float(width)
      @length = Float(length)
      @cut = cut
    end

    def is_placeable_on?(side)
      @cut == :none or @cut == side
    end

    def to_s
      "Tile: id=#{@number}, length=#{@length}"
    end

    def inspect
      "#{@number}:#{@length}:#{@cut}"
    end
  end
end