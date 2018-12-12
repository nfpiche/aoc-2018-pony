require 'pry'
file = ARGV[0]

state = ''
rules = {}

File.open(file).each_with_index do |line, i|
  if i.zero?
    state = line.split(': ').last.chomp.split('').each_with_index.map { |x, ii| [x, ii] }
    next
  end

  next if line.chomp.empty?

  rule, result = line.split(' => ').map(&:chomp)
  rules[rule.split('')] = result
end

start_size = state.size
additional_end_state = (0..999).to_a.map { |i| ['.', start_size + i] }
additional_start_state = (1..1000).to_a.map { |i| ['.', 0 + (-1 * i)] }.reverse
state += additional_end_state
state = additional_start_state + state
first_idx = state.find_index { |c| c.first == '#' }
last_idx = state.each_with_index.reduce(0) { |x, (c, i)| x = c.first == '#' ? i : x }
prev_comparator = state[first_idx..last_idx].map(&:first).join('')
comparator = state[first_idx..last_idx].map(&:first).join('')

count = 1.step do |x|
  next_state = state.clone

  2.upto(state.size - 3) do |i|
    check = [state[i-2].first, state[i-1].first, state[i].first, state[i+1].first, state[i+2].first]

    if rules.key?(check)
      next_state[i] = [rules[check], state[i].last]
    else
      next_state[i] = ['.', state[i].last]
    end
  end

  state = next_state

  first_idx = state.find_index { |c| c.first == '#' }
  last_idx = state.each_with_index.reduce(0) { |xx, (c, i)| xx = c.first == '#' ? i : xx }
  comparator = state[first_idx..last_idx].map(&:first).join('')

  p state.reduce (0) { |acc, (c, v)| acc += c == '#' ? v : 0 } if x == 20
  break x if prev_comparator == comparator
  prev_comparator = comparator
end

s = 50_000_000_000 - count
p state.map { |entry| entry = [entry.first, entry[1] + s] }.reduce (0) { |acc, (c, v)| acc += c == '#' ? v : 0 }
