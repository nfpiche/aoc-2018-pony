require 'pry'

def build(serial)
  (1..300).map do |y|
    (1..300).map { |x| power_level(x, y, serial) }
  end
end

def power_level(x, y, serial)
  rack_id = x + 11
  (((((rack_id * (y + 1)) + serial) * rack_id) / 100) % 10) - 5
end

def max_square(cells, width)
  p width
  values = []
  top = 299 - width
  1.upto(top) do |y|
    1.upto(top) do |x|
      blocks = []
      (y - 1).upto(y + (width - 2)) do |yy|
        (x - 1).upto(x + (width - 2)) do |xx|
          blocks << cells[xx][yy]
        end
      end

      values << [[x + 1, y + 1], width, blocks.sum]
    end
  end

  values.max_by(&:last)
end

cells = build(8444)
p max_square(cells, 3).first

q = (2..30).map { |n| max_square(cells, n) }.max_by(&:last)
p q
