=begin

TODO : finaliser les directions du personnage
et sortir le personnage vers une classe Personnage !	
	
=end

require 'gosu'
require 'opengl'
require 'glu'

OpenGL.load_lib
GLU.load_lib

include OpenGL, GLU

require_relative 'source/camera.rb'

class Window < Gosu::Window
  def initialize
    super(800, 600, false)
    self.caption = 'Resident Evil Style'
  	@character = Gosu::Image.new('gfx/characters/test.png', retro: true)
    @camera = Camera.new(self, 'camera.json')
  end

  def needs_cursor?; true; end

  def button_down(id)
    super
    close! if id == Gosu::KB_ESCAPE
  end

  def update
  	@plane_size = 32
  	@plane_coords ||= [0, 0, 16]

  	vel = 1.0
  	if (Gosu::button_down?(Gosu::KB_LEFT) or Gosu::button_down?(Gosu::KB_RIGHT))
      if (Gosu::button_down?(Gosu::KB_UP) or Gosu::button_down?(Gosu::KB_DOWN))
        vel *= 0.7
      end
	end

	angles = @camera.get_angles
	top    = angles[3]
	right  = angles[4]
	if Gosu::button_down?(Gosu::KB_UP)
		vel = -vel if top.split('')[1] == '-'
		i = (top.split('')[0] == 'x') ? 0 : 1
		@plane_coords[i] -= vel
	elsif Gosu::button_down?(Gosu::KB_DOWN)
		vel = -vel if top.split('')[1] == '-'
		i = (top.split('')[0] == 'x') ? 0 : 1
		@plane_coords[i] += vel
	end	
	if Gosu::button_down?(Gosu::KB_LEFT)
		vel = -vel if right.split('')[1] == '-'
		i = (right.split('')[0] == 'x') ? 0 : 1
		@plane_coords[i] -= vel
	elsif Gosu::button_down?(Gosu::KB_RIGHT)
		vel = -vel if right.split('')[1] == '-'
		i = (right.split('')[0] == 'x') ? 0 : 1
		@plane_coords[i] += vel
	end	
  end

  def opengl_init
	glEnable(GL_DEPTH_TEST)
	glEnable(GL_TEXTURE_2D)
  end

  def draw_character
  	angles = @camera.get_angles
  	glPushMatrix
  	  glTranslatef(*@plane_coords)    
  	  glRotatef(angles[2], 0, 0, 1)
	  glRotatef(angles[0] - 90, 1, 0, 0)
	  glScalef(@plane_size, @plane_size, @plane_size)

	  tex = @character.gl_tex_info
	  glBindTexture(GL_TEXTURE_2D, tex.tex_name)
	  l, r, t, b = tex.left, tex.right, tex.top, tex.bottom

	  glEnable(GL_ALPHA_TEST)
	  glAlphaFunc(GL_GREATER, 0)
	    glBegin(GL_QUADS)
	      glTexCoord2d(l, b); glVertex3f(-0.5, 0.0, 0.0)
	      glTexCoord2d(l, t); glVertex3f(-0.5, 0.0, 1.0)
	      glTexCoord2d(r, t); glVertex3f(0.5, 0.0, 1.0)
	      glTexCoord2d(r, b); glVertex3f(0.5, 0.0, 0.0)
	    glEnd
	  glDisable(GL_ALPHA_TEST)
	glPopMatrix
  end

  def draw
  	gl(10) do
      opengl_init
      @camera.look
      draw_character
  	end

  	@camera.draw
  end
end

Window.new.show