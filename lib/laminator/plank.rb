require 'set'

module Laminator
  class Plank
    attr_reader :number
    attr_reader :width
    attr_reader :length
    attr_reader :cuts

    def initialize(number:, length:, width:, cuts: Set.new())
      @number = number
      @length = Float(length)
      @width = Float(width)
      @cuts = cuts
    end

    def is_placeable_on?(side)
      @cuts.empty? or @cuts.include?(side)
    end

    def inspect
      left = cut_on_left? ? '(' : ''
      right = cut_on_right? ? ')' : ''
      "#{@number}:#{left}#{@length}#{right}"
    end

    def cut_on_right?
      @cuts.include?(:right)
    end

    def cut_on_left?
      @cuts.include?(:left)
    end

    def make_cut(length:, side:, kerf:)
      return nil if length >= @length
      remaining_length = @length - length - kerf
      remaining_cuts = Set.new(@cuts) << (side == :left ? :right : :left)
      @length = length
      @cuts << side
      Plank.new(number: @number, length: remaining_length, width: @width, cuts: remaining_cuts)
    end
  end
end