class Tile

  attr_accessor :front, :back, :revealed

  def initialize
    @front = nil
    @back = nil
    @revealed = false
  end

  def set_back(sym)
    self.back = sym
  end

  def set_front(sym)
    self.front = sym
  end

  def set_revealed(bool)
    self.revealed = bool
  end

  def to_s
    unless self.revealed
      case self.front
      when :f
        return '⚑'.colorize(:red)
      when nil
        return '▩'
      end
    else
      case self.back
      when :b
        return '☣'.colorize(:green)
      when nil
        return '▢'
      else                    #it's a number
        return self.back.to_s
      end
    end
  end

end