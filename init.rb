=begin
  will have to credit UltimeciaFFB if I use the Jill sprite !
=end

require 'gosu'
require 'opengl'
require 'glu'
require 'json'

OpenGL.load_lib
GLU.load_lib

include OpenGL, GLU

require_relative 'source/camera.rb'
require_relative 'source/character.rb'

class Window < Gosu::Window
  attr_reader :keys, :camera, :character
  def initialize
    super(640, 480, false)
    self.caption = 'Resident Evil Style'
    load_keys
    @character = Character.new(self, 'jill.png', [40, 216, 0])
    @camera = Camera.new(self, 'camera2.json')
  end

  def load_keys
    json_file = JSON.parse(File.read('keys.json'))
    @keys = Hash.new
    json_file.each do |key, value|
      @keys[key] = eval(value)
    end
  end

  def needs_cursor?; true; end

  def button_down(id)
    super
    close! if id == @keys["exit"]
    @character.button_down(id)
  end

  def button_up(id)
    @character.button_up(id)
  end

  def allow_position?(position)
    x, y, z = position
    true unless x < 24 or x > 104 or y > 232 or (x > 72 and y > 216) or (x == 24 and y == 216)
  end

  def opengl_init
    glEnable(GL_DEPTH_TEST)
    glEnable(GL_TEXTURE_2D)
  end

  def update
    @character.update
  end

  def draw
    @camera.draw
    @character.draw
    @font ||= Gosu::Font.new(24)
    @font.draw_text(@character.coords.inspect + " -> " + @character.target.inspect, 10, 10, 1000)
  end
end

Window.new.show