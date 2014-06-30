#!/usr/bin/env ruby

require 'prawn'
require 'prawn/measurement_extensions'

require_relative 'lib/laminator'

class Floor
  attr_reader :width
  attr_reader :length
  
  def initialize(width: , length:)
    @width = Float(width)
    @length = Float(length)
  end
end

class Row
  attr_reader :width
  attr_reader :length
  attr_reader :space_left
  attr_reader :tiles
  
  def initialize(length: , width:)
    @length = Float(length)
    @width = Float(width)
    @space_left = @length
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

format = TileFormat.new(length: 1290.0, width: 190.0)
factory = TileFactory.new(tile_format: format)
repository = TileRepository.new(factory: factory, kerf: 4)
floor = Floor.new(length: 5145, width: 4750)

rows = []

remainder = floor.length % format.length

number_of_rows = (floor.width / format.width).ceil

modulus = 5
min_length = 200
min_diff = 100
first_length = 0

number_of_rows.times do |n|
  row = Row.new(length: floor.length, width: format.width)

  #first_length = (remainder / 2 + format.length / modulus * ((n + 2) % modulus)) % format.length
  begin
    len = Random.rand * format.length
    len = (len / 5).round * 5
  end until ((len - first_length).abs) >= min_diff and (len >= min_length) and (floor.length - len) % format.length >= min_length
  first_length = len
  
  row.add_tile(repository.get_tile(length: first_length, side: :left))
  (row.space_left / format.length).floor.times { row.add_tile(factory.new_tile) }
  row.add_tile(repository.get_tile(length: row.space_left, side: :right))

  rows << row
end

Prawn::Document.generate('tiles.pdf', page_layout: floor.length > floor.width ? :landscape : :portrait) do |pdf|
  scale_factor = [pdf.bounds.height / floor.width, pdf.bounds.width / floor.length].min

  pdf.scale(scale_factor, origin: [0, 0]) do
    pdf.line_width = 0.5.mm / scale_factor
    pdf.stroke_rectangle [0, floor.width], floor.length, floor.width

    pdf.line_width = 0.2.mm / scale_factor
    y = 0
    rows.each do |row|
      x = 0
      row.tiles.each do |tile|
        pdf.stroke_rectangle [x, y + tile.width], tile.length, tile.width
        tile_text = case tile.cut
                    when :left then "#{tile.number}R"
                    when :right then "#{tile.number}L"
                    when :none then "#{tile.number}"
                    end
        begin
          pdf.text_box tile_text, at: [x, y + tile.width], width: tile.length, valign: :center, height: tile.width, align: :center, size: 3.mm / scale_factor, overflow: :shrink_to_fit
        rescue
        end
        x += tile.length
      end
      y += row.width
    end
  end
end

puts factory.tile_count
p repository
