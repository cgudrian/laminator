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

  def inspect
    "[#{number}:#{@length}]"
  end
end
