require_relative 'board'

class Game

  attr_accessor :board    #probably shouldn't be accessor

  def initialize(board = Board.new)
    @board = board
  end

  def play
    puts "MINESWEEPER"

    until board.won?
      begin
        mode_prompt
        mode = get_mode

        place_prompt
        place = get_place

        board.click(mode, place)

        if board.lost
          board.display
          lost_prompt
          play_again
          return
        end
      rescue RuntimeError
        puts "That spot has been clicked already. Enter another spot."
        retry
      end
    end
    board.display
    won_prompt
    play_again
  end

  def mode_prompt
    board.display
    puts "Enter r for reveal or f for flag or unflag."
    print '≽ '
  end

  def get_mode
    mode = gets.chomp.to_sym
    return mode if [:r,:f].include?(mode)
    mode_prompt
    get_mode
  end

  def place_prompt
    puts "Enter an x, y location."
    print '≽ '
  end

  def get_place
    place = gets.chomp.split(',').map(&:strip).map(&:to_i) #use Integer instead
    place.reverse!
  end

  def lost_prompt
    puts "You are a good person. This happens to everyone."
    puts "Love yourself."
  end

  def won_prompt
    puts "You did great. Because you are great."
  end

  def play_again
    puts "Would you like to play again? Chump?"
    print '≽ '
    reply = gets.chomp[0].downcase
    if reply == 'y'
      new_game = Game.new
      new_game.play
    else
      puts "Thanks for playing. Chump. Bye. Whatever."
    end
  end

end
