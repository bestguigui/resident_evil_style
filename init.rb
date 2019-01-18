=begin
  for now, I'm doing quick and dirty Z_order sorting using the character Y position.
  I have to change that to sort all drawable elements, related to the camera settings top/right

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
    @character2 ||= Character.new(self, 'jill.png', [104, 168, 0])

    # toute la scène est dessinée en Z == 0 en commençant par le background
    @camera.draw # z == 0
    drawables = []
    @camera.foregrounds.each {|foreground| drawables.push foreground}
    drawables.push([@character, @character.coords[1]])
    drawables.push([@character2, @character2.coords[1]])
    drawables.sort {|a, b| a[1] <=> b[1]}.reverse.each do |drawable| # reverse parce que z- !!!
      if drawable[0].is_a?(Gosu::Image)
        drawable[0].draw(0, 0, 0)
      else
        drawable[0].draw
      end
    end
    @font ||= Gosu::Font.new(24)
    # @font.draw_text(@character.coords.inspect + " -> " + @character.target.inspect, 10, 10, 1000)
  end
end

Window.new.show