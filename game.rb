require 'yaml'
require_relative 'board'
require_relative 'title_screen'

class Game

  attr_reader :board, :title_screen

  def initialize(board = Board.new, title_screen = TitleScreen.new)
    @board = board
    @title_screen = title_screen
  end

  def options
    loop do
      clear_screen
      title_screen.display
      process_action(get_chr, :title_mode)
    end
  end

  def play
    puts "MINESWEEPER"

    until board.won?
      begin
        clear_screen
        board.display
        process_action(get_chr, :board_mode)

        if board.lost
          clear_screen
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
    clear_screen
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
    [place[1] - 1, place[0] - 1]
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





  def clear_screen
    puts "\e[H\e[2J"
  end

  def get_chr
    begin
      system("stty raw -echo")
      str = STDIN.getc
    ensure
      system("stty -raw echo")
    end
  end

  def process_action(chr, mode)
    mode_hash = {:board_mode => self.board,
                  :title_mode => self.title_screen}
    case chr
    when 'w'
      mode_hash[mode].cursor.up
    when 'a'
      mode_hash[mode].cursor.left
    when 's'
      mode_hash[mode].cursor.down
    when 'd'
      mode_hash[mode].cursor.right
    when 'q'
      exit        #maybe make that nicer later
    when 'r'
      board.reveal_tile if mode == :board_mode
    when 'f'
      board.switch_flagged if mode == :board_mode
    when 'o'
      self.options if mode == :board_mode
    when 'e'
      choose_option if mode == :title_mode
    end
  end

  def choose_option
    option = self.title_screen.current_option
    case option
    when :start
      new_game = Game.new
      new_game.play
    when :save
      save_data = self.to_yaml
      File.open('./ok.txt', 'w') { |file| file.puts(save_data) }
    when :load
      YAML::load(File.open('./ok.txt')).play
    when :return
      self.play
    when :exit
      exit
    end
  end

end