class TileRepository
  def initialize(factory: , kerf: 0)
    @kerf = kerf
    @factory = factory
    @tiles = []
  end
  
  def get_tile(length:)
    tile = existing_or_new(@tiles.find { |t| t.length >= length })
    cut_tile(tile, length)
  end

  def get_shortest_tile(length:)
    tile = existing_or_new(@tiles.first)
    cut_tile(tile, length)
  end

  def get_longest_tile(length:)
    tile = existing_or_new(@tiles.last)
    cut_tile(tile, length)
  end

  def inspect
    @tiles.map(&:inspect)
  end

  private

  def existing_or_new(tile)
    @tiles.delete(tile) || @factory.new_tile
  end

  def cut_tile(tile, max_length)
    if tile.length > max_length
      put_tile(Tile.new(number: tile.number, width: tile.width, length: tile.length - max_length - @kerf))
      Tile.new(number: tile.number, width: tile.width, length: max_length)
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
