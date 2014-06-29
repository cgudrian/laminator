#!/usr/bin/env ruby

require 'prawn'

class Floor
  attr_reader :width
  attr_reader :length
  
  def initialize(width: , length:)
    @width = width
    @length = length
  end
end

class TileFormat
  attr_reader :width
  attr_reader :length
  
  def initialize(width: , length:)
    @width = width
    @length = length
  end
end

class Tile
  attr_reader :number
  attr_reader :width
  attr_reader :length
  
  def initialize(number: , width: , length:)
    @number = number
    @width = width
    @length = length
  end

  def to_s
    "Tile: id=#{@id}, length=#{@length}"
  end
end

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

class TileRepository
  def initialize(factory: , kerf: 0)
    @kerf = kerf
    @factory = factory
    @tiles = []
  end
  
  def get_tile(length:)
    tile = find_tile(min_length: length)
    cut_tile(tile, length)
  end

  def get_shortest_tile
    tile = @tiles.first
    if tile
      @tiles.delete(tile)
    else
      @factory.new_tile
    end
  end

  def get_longest_tile
    tile = @tiles.last
    if tile
      @tiles.delete(tile)
    else
      @factory.new_tile
    end
  end

  def to_s
    @tiles.map(&:to_s)
  end

  private

  def find_tile(min_length:)
    tile = @tiles.find { |t| t.length >= min_length }
    if tile
      @tiles.delete(tile)
    else
      @factory.new_tile
    end
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
      @tiles.sort! { |l, r| r.length <=> l.length }
    end
  end
end

class Row
  attr_reader :length
  attr_reader :space_left
  
  def initialize(length:)
    @length = length
    @space_left = length
    @tiles = []
  end

  def tile_count
    @tiles.count
  end

  def add_tile(tile)
    @space_left -= tile.length
    @tiles << tile
  end

  def to_s
  end
end

format = TileFormat.new(length: 1290, width: 130)
factory = TileFactory.new(tile_format: format)
repository = TileRepository.new(factory: factory, kerf: 4)
floor = Floor.new(length: 5000, width: 5000)

rows = []
(Float(floor.width)/format.width).ceil.times do
  row = Row.new(length: floor.length)
  while row.space_left > 0 do
    row.add_tile(repository.get_tile(length: row.space_left))
  end
end
