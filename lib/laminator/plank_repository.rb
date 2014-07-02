module Laminator
  class PlankRepository
    attr_reader :planks
    attr_reader :cut_planks
    attr_reader :wasted_planks

    def initialize(factory:, kerf: 0)
      @kerf = kerf
      @factory = factory
      @planks = []
      @cut_planks = []
      @wasted_planks = []
    end

    def get_plank(length:, side: nil)
      plank = existing_or_new(@planks.find { |p| p.length >= length and p.is_placeable_on?(side) })
      cut_plank(plank, length, side)
    end

    def inspect
      @planks.map(&:inspect)
    end

    def put_plank(plank)
      if not plank.nil? and plank.length > 0
        if plank.cuts.size < 2
          @planks << plank
          @planks.sort! { |l, r| l.length <=> r.length }
        else
          @wasted_planks << plank
        end
      end
    end

    private

    def existing_or_new(plank)
      @planks.delete(plank) || @factory.new_plank
    end

    def cut_plank(plank, max_length, side)
      put_plank(plank.make_cut(length: max_length, side: side, kerf: @kerf))
      @cut_planks << plank if not plank.cuts.empty?
      plank
    end
  end
end