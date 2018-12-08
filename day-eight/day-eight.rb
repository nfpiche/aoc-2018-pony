file = ARGV[0]
part = ARGV[1]
input  = File.open(file).first.split.map(&:to_i)

def part_one(list)
  children = list.shift
  meta = list.shift
  answer = 0

  children.times { answer += part_one(list) }
  meta.times { answer += list.shift }

  answer
end

def part_two(list)
  children = list.shift
  meta = list.shift

  children_values = children.times.map { part_two(list) }
  meta_values = meta.times.map { list.shift }

  return meta_values.sum if children.zero?
  meta_values.sum { |i| children_values[i - 1].to_i }
end

if part == "1"
  p part_one(input)
else
  p part_two(input)
end

