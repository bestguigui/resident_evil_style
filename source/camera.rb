class Camera
  def initialize(window, json_filename)
    @window = window
    @infos = JSON.parse(File.read("cameras/" + json_filename))
    @background = Gosu::Image.new("gfx/backgrounds/" + @infos["background"], retro: true)
    @foregrounds = Array.new
    @infos["foregrounds"].each do |filename, z_order|
      @foregrounds.push [Gosu::Image.new("gfx/foregrounds/" + filename, retro: true), z_order]
    end
  end

  def get_angles
    [@infos["angle_x"], @infos["angle_y"], @infos["angle_z"], @infos["top"], @infos["right"]]
  end

  def look
    ratio = @window.width.to_f / @window.height
    if @window.fullscreen?
      ratio = Gosu::screen_width.to_f / Gosu::screen_height
    end
	  	
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity
    gluPerspective(@infos["fovy"], ratio, 1, 1000)

    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity
    gluLookAt(@infos["x"], @infos["y"], @infos["z"],  
    @infos["t_x"], @infos["t_y"], @infos["t_z"],  0, 0, 1)
  end

  def draw
    scale_x = @window.width / @background.width.to_f
    scale_y = @window.height / @background.height.to_f
    @background.draw(0, 0, 0, scale_x, scale_y)

    @foregrounds.each do |foreground|
      gosu_image, z = foreground
      if @window.character.coords[1] > z
        gosu_image.draw(0, 0, @window.character.coords[1] + 1, scale_x, scale_y)
      end
    end
  end
end