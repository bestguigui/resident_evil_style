class Mouse
  attr_reader :angle
  def initialize(window)
    @window = window
    @x      = @window.mouse_x
    @y      = @window.mouse_y
    @angle  = 0
  end

  def update
    if Gosu::button_down?(Gosu::MS_LEFT) and (@x != @window.mouse_x or @y != @window.mouse_y)
      @angle = Gosu::angle(@window.mouse_x, @window.mouse_y, @x, @y) + 90
      @x     = @window.mouse_x
      @y     = @window.mouse_y
    end
  end

  def to_s
    "x: #@x y: #@y angle: #@angle"
  end
end