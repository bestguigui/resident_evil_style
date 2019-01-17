class Character
  def initialize(window, filename)
    @window = window
    @plane_size = 32
    @coords = [0, 0, 16]
    @sprite = Gosu::Image.new('gfx/characters/' + filename, retro: true)
    @vel = 1.0
    @keys = @window.keys
  end

  def update
    vel = @vel
    if (Gosu::button_down?(@keys["move_left"]) or Gosu::button_down?(@keys["move_right"]))
      if (Gosu::button_down?(@keys["move_up"]) or Gosu::button_down?(@keys["move_down"]))
        vel *= 0.7
      end
    end

    # the "top" and "right" variables are used to use the right axis and the right way 
    # related to the current camera angle
    angles = @window.camera.get_angles
    top    = angles[3]
    right  = angles[4]
    if Gosu::button_down?(@keys["move_up"])
      vel = -vel if top.split('')[1] == '-'
      i = (top.split('')[0] == 'x') ? 0 : 1
      @coords[i] -= vel
    elsif Gosu::button_down?(@keys["move_down"])
      vel = -vel if top.split('')[1] == '-'	
      i = (top.split('')[0] == 'x') ? 0 : 1
      @coords[i] += vel
    end	
    if Gosu::button_down?(@keys["move_left"])
      vel = -vel if right.split('')[1] == '-'
      i = (right.split('')[0] == 'x') ? 0 : 1
      @coords[i] -= vel
    elsif Gosu::button_down?(@keys["move_right"])
      vel = -vel if right.split('')[1] == '-'
      i = (right.split('')[0] == 'x') ? 0 : 1
      @coords[i] += vel
    end	
  end

  def draw
    angles = @window.camera.get_angles
    glPushMatrix
    glTranslatef(*@coords)    
      glRotatef(angles[2], 0, 0, 1)
      glRotatef(angles[0] - 90, 1, 0, 0)
      glScalef(@plane_size, @plane_size, @plane_size)
      tex = @sprite.gl_tex_info
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
end