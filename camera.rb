require 'json'

class Camera
	def initialize(window, json_file)
		@window = window
		@infos = JSON.parse(File.read(json_file))
		@background = Gosu::Image.new("backgrounds/" + @infos["image"], retro: true)
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
		@background.draw(0, 0, 0)
	end
end