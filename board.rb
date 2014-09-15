# coding: utf-8
#set bomb count based on size and/or difficulty
require 'colorize'
require_relative 'tile'
require_relative 'cursor'
class Board

  attr_accessor :rows, :lost , :cursor

  def initialize(cursor = Cursor.new)
    generate_rows
    label_tiles
    @lost = false
    @cursor = cursor
  end

  def generate_rows
    @rows = Array.new(9) { Array.new(9) {Tile.new} } #want to change vals tho
  end

  # def click(mode, pos)
  #   case mode
  #   when :f
  #     switch_flagged(pos) #kina
  #   when :r
  #     reveal_tile(pos)
  #   end
  # end

  def reveal_tile(pos = self.cursor.pos)
    raise "spot taken" if revealed?(pos)
    reveal_bombs if bomb?(pos)
    cascade(pos) unless bomb?(pos)
  end

  def switch_flagged(pos = self.cursor.pos)
    raise "spot taken" if self[pos].revealed
    self[pos].set_front( self[pos].front ? nil : :f )
  end

  def reveal_bombs
    all_pos.each { |pos| self[pos].set_revealed(true) if bomb?(pos) }
    self.lost = true
  end

  def cascade(pos)
    self[pos].revealed = true
    return if numbered?(pos)

    adj_arr(pos).each do |adj_pos|
      self[adj_pos].revealed = true if numbered?(adj_pos)
      cascade(adj_pos) if cascade?(adj_pos)
    end
  end

  def cascade?(pos)
    !( numbered?(pos) || bomb?(pos) || revealed?(pos) )
  end

  def numbered?(pos)
    self[pos].back.is_a?(Integer)
  end

  def revealed?(pos)
    self[pos].revealed
  end

  def bomb?(pos)
    self[pos].back == :b
  end

  def won?
    all_pos.all? { |pos| bomb?(pos) ? !revealed?(pos) : revealed?(pos) }
  end

  def all_pos
    pos = []
    self.rows.count.times do |i|
      rows[0].count.times do |j|
        pos << [i,j]
      end
    end
    pos
  end

  def label_tiles
    place_bombs
    label_bomb_count
  end

  def place_bombs
    bomb_spots = all_pos.sample(10)          #make this a fn of size
    bomb_spots.each { |pos| self[pos].set_back(:b) }
  end

  def label_bomb_count
    all_pos.each do |pos|
      unless bomb?(pos) || find_bomb_count(pos) == 0
        self[pos].back = find_bomb_count(pos)
      end
    end
  end

  def find_bomb_count(pos)
    bomb_count = 0
    adj_arr(pos).each do |adj_pos|
      bomb_count += 1 if bomb?(adj_pos)
    end

    bomb_count
  end

  def adj_arr(pos)          #hardcode it in
    adj_arr = []
    3.times do |i|
      adj_arr << [pos[0] - 1, pos[1] - 1 + i]
    end

    adj_arr << [pos[0], pos[1] - 1]
    adj_arr << [pos[0], pos[1] + 1]

    3.times do |i|
      adj_arr << [pos[0] + 1, pos[1] - 1 + i]
    end
    adj_arr.select{|pos| all_pos.include?(pos)}
  end

  def [](pos)
    self.rows[pos[0]][pos[1]]
  end

  def []=(pos,sym)
    self.rows[pos[0]][pos[1]] = sym
  end

  def render
    board_chars = []
    self.rows.each do |row|
      board_chars << row.map(&:to_s)
    end

    board_chars[cursor.row][cursor.col] = board_chars[cursor.row][cursor.col].colorize(:light_white)
    # how is that a color

    str = '  '
    str << FANCY_INTEGERS[0...9].join(' ')        #based on width
    str << "\n"
    board_chars.each_with_index do |row, y|
      str << FANCY_INTEGERS[y] << " "
      str << row.join(' ')
      str << "\n"
    end
    str
  end

  def display
    puts render
  end

  # %w(➀ ➁ ➂ ➃ ➄ ➅ ➆ ➇ ➈ ➉) optional font

  FANCY_INTEGERS = %w(❶ ❷ ❸ ❹ ❺ ❻ ❼ ❽ ❾ ❿)#.map{|n| n.colorize(:light_white)}
end