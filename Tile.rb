class Tile

  attr_accessor :value

  def initialize(value)
    @value=value
  end

  def to_s
    return self.value.to_s if self.value > 0
    0
  end

end
