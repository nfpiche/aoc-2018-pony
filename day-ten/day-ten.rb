file = ARGV[0]

class StarGrid
  def initialize()
    @stars = []
  end

  def insert(position, velocity)
    star = Star.new(position, velocity)
    @stars << star
  end

  def draw
    previous_y_range = Float::INFINITY
    current_y_range = -Float::INFINITY
    second = 0

    loop do
      current_y_min, current_y_max = @stars.map(&:position).map(&:last).minmax
      current_y_range = current_y_max - current_y_min

      if current_y_range > previous_y_range
        @stars.each(&:move_back)
        second -= 1
        break
      else
        previous_y_range = current_y_range
        second += 1
        @stars.each(&:move)
      end
    end

    points = @stars.map(&:position)
    xmin, xmax = points.map(&:first).minmax
    ymin, ymax = points.map(&:last).minmax

    ymin.upto(ymax).each do |y|
      line = ""
      xmin.upto(xmax).each do |x|
        line += points.include?([x, y]) ? '@' : ' '
      end
      puts line
    end

    p second
  end
end

class Star
  attr_reader :position, :velocity

  def initialize(position, velocity)
    @position = position
    @velocity = velocity
  end

  def move
    next_x = position.first + velocity.first
    next_y = position.last + velocity.last

    @position = [next_x, next_y]
  end

  def move_back
    next_x = position.first - velocity.first
    next_y = position.last - velocity.last

    @position = [next_x, next_y]
  end
end

star_grid = StarGrid.new

File.open(file).each do |line|
  position, velocity = line.
    match(/position=<(.*)> velocity=<(.*)>/).captures.
    map { |e| e.split(' ').map(&:to_i) }

  star_grid.insert(position, velocity)
end

star_grid.draw
