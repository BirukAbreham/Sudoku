require_relative 'Board'

class Game
  
  def initialize(file=nil)
    if file.nil?
      @board = Board.from_file
    else
      @board = Board.from_file(file)
    end
  end

  def play
    system("clear")
    puts "Welcome to Sudoku puzzle game, enjoy!"
    @board.render
    while !@board.solved?
      self.prompt
      @board.render
    end
    self.solved
  end

  def prompt
    puts "Fill the '/' characters with valid number to solve the puzzle"
    puts "Enter the position you want put a number e.g. row & column 2, 3"
    pos = gets.chomp.split(",")
    pos = pos.map { |i| i.to_i }
    puts "Enter the number between 1-9 for the given position"
    num = gets.chomp.to_i
    @board[pos] = num
  end

  def solved
    puts "*** Sloved Sudoku Puzzle ***"
  end

end

if $PROGRAM_NAME == __FILE__
  game = Game.new('puzzle/sudoku1.txt')
  game.play
end
