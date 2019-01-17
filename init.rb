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
  attr_reader :keys, :camera
  def initialize
    super(800, 600, false)
    self.caption = 'Resident Evil Style'
    load_keys
    @character = Character.new(self, 'test.png')
    @camera = Camera.new(self, 'camera.json')
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
  end

  def update
    @character.update
  end

  def opengl_init
    glEnable(GL_DEPTH_TEST)
    glEnable(GL_TEXTURE_2D)
  end

  def draw
    gl(10) do
      opengl_init
      @camera.look
      @character.draw
    end

    @camera.draw
  end
end

Window.new.show