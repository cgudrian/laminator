#!/usr/bin/env ruby

require 'prawn'
require_relative 'lib/laminator'

class Floor
  attr_reader :width
  attr_reader :length
  
  def initialize(width: , length:)
    @width = width
    @length = length
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
    "Row with #{tile_count} tiles"
  end

  def inspect
    @tiles.map(&:inspect)
  end  
end

format = TileFormat.new(length: 1290, width: 230)
factory = TileFactory.new(tile_format: format)
repository = TileRepository.new(factory: factory, kerf: 4)
floor = Floor.new(length: 5000, width: 5000)

rows = []
(Float(floor.width)/format.width).ceil.times do
  row = Row.new(length: floor.length)
  row.add_tile(repository.get_longest_tile(length: row.space_left))
  while row.space_left > 0 do
    row.add_tile(repository.get_tile(length: row.space_left))
  end
  p row
end

puts 'Repository'
p repository
