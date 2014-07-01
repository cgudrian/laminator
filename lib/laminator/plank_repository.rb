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

    def inspect
      @planks.map(&:inspect)
    end

    private

    def existing_or_new(plank)
      @planks.delete(plank) || @factory.new_plank
    end

    def cut_plank(plank, max_length, side)
      put_plank(plank.make_cut(length: max_length, side: side, kerf: @kerf))
      plank
    end

    def put_plank(plank)
      if not plank.nil? and plank.length > 0
        @planks << plank
        @planks.sort! { |l, r| l.length <=> r.length }
      end
    end
  end
end