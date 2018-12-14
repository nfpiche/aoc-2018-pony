require 'pry'

module Directions
  UP = :UP
  DOWN = :DOWN
  LEFT = :LEFT
  RIGHT = :RIGHT
end

CART_SHAPES = {
  '^' => Directions::UP,
  '>' => Directions::RIGHT,
  'v' => Directions::DOWN,
  '<' => Directions::LEFT
}

class Cart
  @@movement = {
    Directions::UP => [0, -1],
    Directions::DOWN  => [0, 1],
    Directions::LEFT => [-1, 0],
    Directions::RIGHT => [1, 0],
  }

  @@left_and_right = [ Directions::LEFT, Directions::RIGHT ]

  attr_reader :position, :moving

  def initialize(x, y, direction)
    @position = [x, y]
    @intersection_count = 0
    @facing = direction
    @moving = true
  end

  def to_s
    "Facing: [#{@facing}] at position #{@position.first},#{@position.last}"
  end

  def moving?
    @moving
  end

  def stop
    @moving = false
  end

  def shift(grid)
    change = @@movement[@facing]
    @position = @position.zip(change).map(&:sum)
    track = grid[@position.first][@position.last]

    handle_straight if track == '-' || track == '|'
    intersection_move if track == '+'
    handle_turn(track) if track == '/' || track == '\\'
  end

  private

  def handle_left
    case @facing
      when Directions::UP then move(Directions::LEFT)
      when Directions::DOWN then move(Directions::RIGHT)
      when Directions::LEFT then move(Directions::DOWN)
      when Directions::RIGHT then move(Directions::UP)
    end
  end

  def handle_straight
    move(@facing)
  end

  def handle_right
    case @facing
      when Directions::UP then move(Directions::RIGHT)
      when Directions::DOWN then move(Directions::LEFT)
      when Directions::LEFT then move(Directions::UP)
      when Directions::RIGHT then move(Directions::DOWN)
    end
  end

  def move(direction)
    @facing = direction
  end

  def intersection_move
    case @intersection_count % 3
      when 0 then handle_left
      when 1 then handle_straight
      when 2 then handle_right
    end
    @intersection_count += 1
  end

  def handle_turn(track)
    if track == '/'
      @@left_and_right.include?(@facing) ?  handle_left : handle_right
    else
      @@left_and_right.include?(@facing) ?  handle_right : handle_left
    end
  end
end

file = ARGV[0]
carts = []
x = 0
y = 0

grid = File.open(file).each_with_object([]) do |line, acc|
  line.split('').each do |point|
    if acc[x].nil?
      acc[x] = []
    end

    if CART_SHAPES.key?(point)
      carts << Cart.new(x, y, CART_SHAPES[point])
      acc[x][y] = ['^', 'v'].include?(point) ? '|' : '-'
    else
      acc[x][y] = point
    end

    x += 1
  end
  x = 0
  y += 1
end

def collision?(carts)
  carts.map(&:position).group_by(&:itself).values.any? { |g| g.size > 1 }
end

first_collision = nil

loop do
  carts.sort_by!(&:position)

  carts.each do |c|
    c.shift(grid)

    if collision?(carts)
      collision_point = carts.map(&:position).group_by(&:itself).values.select { |g| g.size > 1 }.first.first
      first_collision = collision_point if first_collision.nil?
      carts.select { |cc| cc.position == collision_point }.map(&:stop)
    end
  end

  carts.select!(&:moving?)
  break if carts.size == 1
end

p first_collision
p carts.first.position
