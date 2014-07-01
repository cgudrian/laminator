require 'set'

module Laminator
  class Plank
    attr_reader :number
    attr_reader :width
    attr_reader :length
    attr_reader :cut
    attr_reader :cuts

    def initialize(number:, length:, width:, cut: :none)
      @number = number
      @length = Float(length)
      @width = Float(width)
      @cut = cut
      @cuts = Set.new()
      @cuts << cut if cut != :none
    end

    def is_placeable_on?(side)
      @cut == :none or @cut == side
    end

    def inspect
      "#{@number}:#{@length}:#{@cuts}"
    end

    def make_cut(length:, side:, kerf:)
      return nil if length >= @length
      @length = length
      @cuts << side
      Plank.new(number: @number, length: @length - length - kerf, width: @width, cut: @cuts << (side == :left ? :right : :left))
    end
  end
end