require 'gosu'

class Window < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = 'Resident Evil Style'
  end

  def needs_cursor?; true; end

  def button_down(id)
    super
    close! if id == Gosu::KB_ESCAPE
  end

  def update

  end

  def draw

  end
end

Window.new.show