require 'colorize'
require 'byebug'
require_relative 'Tile'

class Board
  
  def initialize(grid)
    @grid = grid    
  end

  def self.from_file(sudoku_file='puzzle/sudoku1.txt')
    # debugger
    file_grid = Array.new(9) { [] }

    raise "File does not exits" if !File.exist?(sudoku_file)

    file = File.open(sudoku_file)
    line_arr = file.readlines
    line_arr.map! { |line| line.chomp }

    line_arr.each_with_index do |line, idx|
      nums = line.split("").map { |char| char.to_i }
      nums.each do |num|
        file_grid[idx] << Tile.new(num)
      end
    end
    
    Board.new(file_grid)
  end

  def render
    (0...@grid.length).each do |i|
      if i == 0
        print " ".ljust(3, "  ")+"#{i}".ljust(3, "  ")
      else
        if i%3 == 0
          print " #{i}".ljust(4, " ")
        else
          print "#{i}".ljust(3, "  ")
        end
      end
    end
    puts
    puts "_"*34
    @grid.each_with_index do |line, row|
      print "#{row}|".ljust(3, "  ")
      line.each_with_index do |tile, idx|
        if tile.to_s == 0
          print "/".ljust(3, "  ").colorize(:color => :yellow, :background => :black)
        else
          print "#{tile.to_s}".ljust(3, "  ").colorize(:color => :green, :background => :black)
        end
        if (idx+1)%3 == 0
          print "|"
        end
      end
      puts
      puts "_"*34 if (row+1)%3 == 0
    end
    puts
  end
  
  def []=(position, tile_value)
    @grid[ position[0] ][ position[1] ] = Tile.new(tile_value)
  end

  def [](position)
    @grid[ position[0] ][ position[1] ]
  end

  def rows_solved?
    @grid.each do |tiles_row|
      temp = []
      tiles_row.each { |tile| temp << tile.value }
      temp = temp.uniq
      return false if temp.length != 9 || temp.sum != 45
    end
    true
  end

  def cols_solved?
    grid_traspose = @grid.transpose
    grid_traspose.each do |tiles_row|
      temp = []
      tiles_row.each { |tile| temp << tile.value }
      temp = temp.uniq
      return false if temp.length != 9 || temp.sum != 45
    end
    true
  end

  def blocks_sloved?
    blocks = Array.new(@grid.length) { [] }
    @grid.each_with_index do |tiles_row, idx|
      if idx >= 0 && idx < 3
        blocks[0] << tiles_row[0...3]
        blocks[1] << tiles_row[3...6]
        blocks[2] << tiles_row[6...9]
      elsif idx >= 3 && idx < 6
        blocks[3] << tiles_row[0...3]
        blocks[4] << tiles_row[3...6]
        blocks[5] << tiles_row[6...9]
      elsif idx >= 6 && idx < 9
        blocks[6] << tiles_row[0...3]
        blocks[7] << tiles_row[3...6]
        blocks[8] << tiles_row[6...9]
      end
    end
    blocks.each do |block|
      return false if !self.block_sloved?(block)
    end
    true
  end

  def block_sloved?(block)
    block = block.flatten
    temp = []
    block.each { |tile| temp << tile.value }
    temp = temp.uniq
    return false if temp.length != 9 || temp.sum != 45
    true
  end

  def solved?
    rows_solved? && cols_solved? && blocks_sloved?
  end

end
