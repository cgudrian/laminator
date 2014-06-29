class TileFactory
  attr_reader :tile_count
  
  def initialize(tile_format:)
    @tile_count = 0
    @tile_width = tile_format.width
    @tile_length = tile_format.length
  end

  def new_tile
    @tile_count += 1
    Tile.new(number: @tile_count, width: @tile_width, length: @tile_length)
  end
end
