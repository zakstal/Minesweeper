require_relative 'game'

if __FILE__ == $PROGRAM_NAME
  minesweeper = Game.new
  minesweeper.play
end