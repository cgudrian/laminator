module Laminator
  class PlankRepository
    def initialize(factory:, kerf: 0)
      @kerf = kerf
      @factory = factory
      @planks = []
    end

    def get_plank(length:, side:)
      plank = existing_or_new(@planks.find { |p| p.length >= length and p.is_placeable_on?(side) })
      cut_plank(plank, length, side)
    end

    def get_shortest_plank(length:, side:)
      plank = existing_or_new(@planks.find { |p| p.is_placeable_on?(side) })
      cut_plank(plank, length, side)
    end

    def inspect
      @planks.map(&:inspect)
    end

    private

    def existing_or_new(plank)
      @planks.delete(plank) || @factory.new_plank
    end

    def merge_cut(cut1, cut2)
      if cut1 == cut2
        cut1
      elsif cut1 == :none
        cut2
      elsif cut2 == :none
        cut1
      else
        :both
      end
    end

    def cut_plank(plank, max_length, side)
      if plank.length > max_length
        other_plank = Plank.new(number: plank.number, width: plank.width, length: plank.length - max_length - @kerf, cut: merge_cut(plank.cut, side == :right ? :left : :right))
        put_plank(other_plank)
        Plank.new(number: plank.number, width: plank.width, length: max_length, cut: merge_cut(plank.cut, side))
      else
        plank
      end
    end

    def put_plank(plank)
      if plank.length > 0
        @planks << plank
        @planks.sort! { |l, r| l.length <=> r.length }
      end
    end
  end
end