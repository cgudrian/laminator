class TileRepository
  def initialize(factory: , kerf: 0)
    @kerf = kerf
    @factory = factory
    @tiles = []
  end
  
  def get_tile(length:, side:)
    tile = existing_or_new(@tiles.find { |t| t.length >= length and t.is_placeable_on?(side) })
    cut_tile(tile, length, side)
  end

  def get_shortest_tile(length:, side:)
    tile = existing_or_new(@tiles.find { |t| t.is_placeable_on?(side) })
    cut_tile(tile, length, side)
  end

  def inspect
    @tiles.map(&:inspect)
  end

  private

  def existing_or_new(tile)
    @tiles.delete(tile) || @factory.new_tile
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

  def cut_tile(tile, max_length, side)
    if tile.length > max_length
      remaining_tile = Tile.new(number: tile.number, width: tile.width, length: tile.length - max_length - @kerf, cut: merge_cut(tile.cut, side == :right ? :left : :right))
      put_tile(remaining_tile)
      Tile.new(number: tile.number, width: tile.width, length: max_length, cut: merge_cut(tile.cut, side))
    else
      tile
    end
  end

  def put_tile(tile)
    if tile.length > 0
      @tiles << tile
      @tiles.sort! { |l, r| l.length <=> r.length }
    end
  end
end
