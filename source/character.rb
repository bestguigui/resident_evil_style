class Character
  attr_reader :coords, :target
  def initialize(window, filename, coords = [0, 0, 0])
    @window = window
    @plane_size = 32
    @coords = coords
    @sprite = Gosu::Image.load_tiles('gfx/characters/' + filename, @plane_size, @plane_size, retro: true)
    @orientations = [:north, :east, :south, :west]
    @orientation = :south
    @frame = 1
    @frame_tick = nil
    @frame_duration = 150
    @left_foot = false
    @velocity = 1.15
    @target = nil
    @keys = @window.keys
    @keystates = Hash.new
  end

  def button_down(id)
    if @keys.has_value?(id)
      @keystates[id] = Gosu::milliseconds
    end
  end

  def button_up(id)
    if @keys.has_value?(id)
      @keystates.delete(id)
    end
  end

  def update
    vel = 16
    angles = @window.camera.get_angles
    top    = angles[3]
    right  = angles[4]

    if !@keystates.keys.empty? and @target.nil?
      last_pressed_key = @keystates.key(@keystates.values.sort.last)
      @target = [@coords[0], @coords[1], @coords[2]]
      case last_pressed_key
      when @keys["move_up"]
        vel = -vel if top.split('')[1] == '-'
        i = (top.split('')[0] == 'x') ? 0 : 1
        @target[i] -= vel
        @orientation = :north
      when @keys["move_down"]
        vel = -vel if top.split('')[1] == '-'	
        i = (top.split('')[0] == 'x') ? 0 : 1
        @target[i] += vel
        @orientation = :south
      when @keys["move_left"]
        vel = -vel if right.split('')[1] == '-'
        i = (right.split('')[0] == 'x') ? 0 : 1
        @target[i] -= vel
        @orientation = :west
      when @keys["move_right"]
        vel = -vel if right.split('')[1] == '-'
        i = (right.split('')[0] == 'x') ? 0 : 1
        @target[i] += vel
        @orientation = :east
      end    
    end

    unless @target.nil?
      @frame_tick = Gosu::milliseconds if @frame_tick.nil?
      if Gosu::milliseconds - @frame_tick >= @frame_duration
        if @frame == 1
          if @left_foot
            @frame = 2
            @left_foot = false
          else
            @frame = 0
            @left_foot = true
          end
        else
          @frame = 1
        end
        @frame_tick = Gosu::milliseconds
      end

      if @coords[0] != @target[0]
        if @coords[0] > @target[0]
          @coords[0] -= @velocity
          @coords[0] = @target[0] if @coords[0] < @target[0]
        elsif @coords[0] < @target[0]
          @coords[0] += @velocity
          @coords[0] = @target[0] if @coords[0] > @target[0]
        end
      elsif @coords[1] != @target[1]
        if @coords[1] > @target[1]
          @coords[1] -= @velocity
          @coords[1] = @target[1] if @coords[1] < @target[1]
        elsif @coords[1] < @target[1]
          @coords[1] += @velocity
          @coords[1] = @target[1] if @coords[1] > @target[1]
        end
      end 
      if (@coords[0] == @target[0] and @coords[1] == @target[1] and @coords[2] == @target[2])
        @target = nil 
      end
    else
      @frame = 1
      @frame_tick = nil
    end	
  end

  def draw
    angles = @window.camera.get_angles
    glPushMatrix
      glTranslatef(*@coords)    
      glRotatef(angles[2], 0, 0, 1)
      glRotatef(angles[0] - 90, 1, 0, 0)
      glScalef(@plane_size, @plane_size, @plane_size)
      image_index = @orientations.index(@orientation) * 3 + @frame
      tex = @sprite[image_index].gl_tex_info
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