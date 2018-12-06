require 'set'

class PointData
  attr_reader :points , :infinites, :max_x, :max_y

  def initialize(file_name)
    @points = {}
    @points.default_proc = -> (h, k) { h[k] = 1 }
    @infinites = Set[]
    @max_x = -1
    @max_y = -1

    process_input(file_name)
  end

  def add_infinite(point)
    infinites.add(point)
  end

  def add_count_for(point)
    points[point] += 1
  end

  def infinite?(point)
    infinites.include?(point)
  end

  private

  def process_input(file_name)
    File.open(file_name).each do |line|
      x, y = line.split(', ').map(&:to_i)
      point = Point.new(x, y)
      points[point] = 0
      calculate_next_maxes(x, y)
    end
  end

  def calculate_next_maxes(x, y)
    @max_x = [max_x, x].max
    @max_y = [max_y, y].max
  end
end

class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def distance(that)
    (@x - that.x).abs + (@y - that.y).abs
  end
end


def part_one(data)
  top_x = data.max_x - 1
  top_y = data.max_y - 1

  (0..top_x).each do |x|
    (0..top_y).each do |y|
      min_point = Point.new(0, 0)
      min_distance = top_x + top_y
      skip = false

      data.points.keys.each do |point|
        other_point = Point.new(x, y)
        check_distance = point.distance(other_point)

        if check_distance < min_distance
          min_point = point
          min_distance = check_distance
          skip = false
        elsif check_distance == min_distance
          skip = true
        end
      end

      if at_edge?(x, y, top_x, top_y)
        data.add_infinite(min_point)
      end

      data.add_count_for(min_point) unless skip
    end
  end

  data.points.
    reject { |k, v| data.infinite?(k) }.
    max_by { |k, v| v }.last
end

def at_edge?(x, y, top_x, top_y)
  [top_x, 0].include?(x) || [top_y, 0].include?(y)
end

def part_two(data)
  count = 0

  (0..data.max_x).each do |x|
    (0..data.max_y).each do |y|
      total_distance = data.points.keys.inject(0) do |current_distance, point|
        other_point = Point.new(x, y)
        current_distance += point.distance(other_point)
      end

      count += 1 if total_distance < 10000
    end
  end

  count
end

part = ARGV[0]

if part == "1"
  data = PointData.new('./input.txt')
  p part_one(data)
elsif part == "2"
  data = PointData.new('./input.txt')
  p part_two(data)
else
  raise "Use 1 or 2 plz"
end
