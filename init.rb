require 'gosu'
require 'opengl'
require 'glu'

OpenGL.load_lib
GLU.load_lib

include OpenGL, GLU

require_relative 'mouse.rb'

class Window < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = 'Resident Evil Style'

    mouse_init
  end

  def mouse_init
    self.mouse_x = self.width / 2
    self.mouse_y = self.height / 2
    @mouse       = Mouse.new(self)
  end

  def needs_cursor?; true; end

  def button_down(id)
    super
    close! if id == Gosu::KB_ESCAPE
  end

  def update
    @mouse.update
    self.caption = @mouse
  end

  def draw

  end
end

Window.new.show