require 'colorize'
require_relative 'cursor'

class TitleScreen

  attr_reader :options, :cursor

  def initialize(cursor = Cursor.new(1,5))
    @cursor = cursor
    @options = [[:start], [:save], [:load], [:return], [:exit]]
                  #it has to be this way for cursor
                  #MAKE CONSTANT!!
  end

  def current_option
    self.options[self.cursor.row][0]
  end

  def title
    "MINESWEEPER"
  end

  def save(board)

  end

  def start_game

  end

  def render
    str = title << "\n"
    syms_arr = self.options.flatten
    syms_arr.each_with_index do |sym, i|
      if i == self.cursor.row
        str << sym.to_s.colorize(:light_white)
      else
        str << sym.to_s
      end
      str << "\n"
    end
    str
  end

  def display
    puts render
  end

end