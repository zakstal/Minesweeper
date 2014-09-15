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

end