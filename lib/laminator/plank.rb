module Laminator
  class Plank
    attr_reader :number
    attr_reader :width
    attr_reader :length
    attr_reader :cuts

    # Creates a new plank of the given size.
    #
    # The +width+ and +length+ parameters are converted to Floats before saved.
    #
    #@param number the number of the plank
    #@param length the length of the plank
    #@param width the width of the plank
    #@param cuts[:left, :right] the cuts of the plank
    def initialize(number:, length:, width:, cuts: [])
      @number = number
      @length = Float(length)
      @width = Float(width)
      @cuts = cuts
    end

    # Returns +true+ if this plank can be placed on the given side of the row.
    # @param [:left: right] side the queried side
    def is_placeable_on?(side)
      @cuts.empty? or @cuts.include?(side)
    end

    # Returns +true+ if this plank has a cut on its left side.
    def cut_on_left?
      @cuts.include?(:left)
    end

    # Returns true if this plank has a cut on its right side.
    def cut_on_right?
      @cuts.include(:right)
    end

    def inspect
      left = cut_on_left? ? '(' : ''
      right = cut_on_right? ? ')' : ''
      "#{@number}:#{left}#{@length}#{right}"
    end

    # Cuts this plank to the given length.
    # The cut is made on the given side.
    # If the plank is shorter than the requested length
    # no cut is made.
    #
    #@param length the length of the plank after being cut
    #@param side the side on which the cut is to be made
    #@param kerf the kerf of the saw
    #@return [Plank] the remaining plank
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