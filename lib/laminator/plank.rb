module Laminator
  class Plank
    attr_reader :number
    attr_reader :width
    attr_reader :length
    attr_reader :cuts

    # Creates a new plank of the given size
    #
    # @param number the number of the plank
    # @param length the length of the plank
    # @param width the width of the plank
    # @param cuts[:left, :right] the cuts of the plank
    def initialize(number:, length:, width:, cuts: [])
      @number = number
      @length = Float(length)
      @width = Float(width)
      @cuts = cuts
    end

    # Returns true if this plank can be placed on the given side of the row.
    # @param [:left: right] side the queried side
    def is_placeable_on?(side)
      @cuts.empty? or @cuts.include?(side)
    end

    def inspect
      left = cut_on_left? ? '(' : ''
      right = cut_on_right? ? ')' : ''
      "#{@number}:#{left}#{@length}#{right}"
    end

    def make_cut!(length:, side:, kerf: 0)
      return nil if length >= @length
      remaining_length = @length - length - kerf
      remaining_cuts = @cuts | [side == :left ? :right : :left]
      @length = length
      @cuts << side
      Plank.new(number: @number, length: remaining_length, width: @width, cuts: remaining_cuts)
    end
  end
end