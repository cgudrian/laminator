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
  attr_reader :width
  attr_reader :length
  attr_reader :space_left
  attr_reader :tiles
  
  def initialize(length: , width:)
    @length = length
    @width = width
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

class Strategy
  def initialize(floor: , tile_format: )
  end
end

class LeastWasteStrategy < Strategy
end

class BalancedStrategy < Strategy
end

def offset(length, phases, index)
  length * phases[index % phases.count] / 360.0
end

format = TileFormat.new(length: 1290.0, width: 190.0)
factory = TileFactory.new(tile_format: format)
repository = TileRepository.new(factory: factory, kerf: 4)
floor = Floor.new(length: 5145.0, width: 4750.0)

rows = []

first_len = 0
remainder = floor.length % format.length
(Float(floor.width)/format.width).ceil.times do |n|
  row = Row.new(length: floor.length, width: format.width)

  #row.add_tile(repository.get_longest_tile(length: row.space_left))
  #while row.space_left > 0 do
  #  row.add_tile(repository.get_tile(length: row.space_left))
  #end

  #first_len = remainder / 2.0 + offset(format.length, [0, 120, 240], n)
  first_len = (200 + first_len + (Random.rand * format.length / 2)).ceil % format.length
  row.add_tile(repository.get_tile(length: first_len % format.length))
  while row.space_left > 0 do
    row.add_tile(repository.get_tile(length: row.space_left))
  end

  rows << row
end

Prawn::Document.generate('tiles.pdf') do
  scale_factor = [bounds.height / floor.width, bounds.width / floor.length].min
  scale(scale_factor, origin: [0, 0]) do
    stroke_rectangle [0, floor.width], floor.length, floor.width
    y = 0
    rows.each do |row|
      x = 0
      row.tiles.each do |tile|
        stroke_rectangle [x, y + tile.width], tile.length, tile.width
        x += tile.length
      end
      y += row.width
    end
  end
end

puts factory.tile_count
p repository
