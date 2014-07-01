#!/usr/bin/env ruby

require 'prawn'
require 'prawn/measurement_extensions'

require_relative 'lib/laminator'

class Floor
  attr_reader :width
  attr_reader :length

  def initialize(width:, length:)
    @width = Float(width)
    @length = Float(length)
  end
end

class Row
  attr_reader :width
  attr_reader :length
  attr_reader :space_left
  attr_reader :planks

  def initialize(length:, width:)
    @length = Float(length)
    @width = Float(width)
    @space_left = @length
    @planks = []
  end

  def plank_count
    @planks.count
  end

  def add_plank(plank)
    @space_left -= plank.length
    @planks << plank
  end

  def inspect
    @planks.map(&:inspect)
  end
end

class Strategy
end

class LeastWasteStrategy < Strategy
end

class BalancedStrategy < Strategy
end


plank_length = 1290.0
plank_width = 190.0

factory = Laminator::PlankFactory.new(plank_length: plank_length, plank_width: plank_width)
repository = Laminator::PlankRepository.new(factory: factory, kerf: 4)
floor = Floor.new(length: 5145, width: 4750)

rows = []

#remainder = floor.length % size.length

number_of_rows = (floor.width / plank_width).ceil

#modulus = 5
min_length = 200
min_diff = 100
first_length = 0

number_of_rows.times do |n|
  row = Row.new(length: floor.length, width: plank_width)

  #first_length = (remainder / 2 + size.length / modulus * ((n + 2) % modulus)) % size.length
  begin
    len = Random.rand * plank_length
    len = (len / 5).round * 5
  end until ((len - first_length).abs) >= min_diff and (len >= min_length) and (floor.length - len) % plank_length >= min_length
  first_length = len

  row.add_plank(repository.get_plank(length: first_length, side: :left))
  (row.space_left / plank_length).floor.times { row.add_plank(factory.new_plank) }
  row.add_plank(repository.get_plank(length: row.space_left, side: :right))

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
      row.planks.each do |plank|
        pdf.stroke_rectangle [x, y + plank.width], plank.length, plank.width
        tile_text = case plank.cut
                    when :left
                      "#{plank.number}R"
                    when :right
                      "#{plank.number}L"
                    when :none
                      "#{plank.number}"
                    else
                      "?#{plank.number}"
                    end
        begin
          pdf.text_box tile_text, at: [x, y + plank.width], width: plank.length, valign: :center, height: plank.width, align: :center, size: 3.mm / scale_factor, overflow: :shrink_to_fit
        rescue
          puts 'Some text could not be printed.'
        end
        x += plank.length
      end
      y += row.width
    end
  end
end

puts factory.plank_count
p repository
