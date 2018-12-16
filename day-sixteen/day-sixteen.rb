require 'pry'

def compare(a, comparator, b)
  a.send(comparator, b) ? 1 : 0
end

funs = {
  addr: -> (reg_1, reg_2, register) { register[reg_1] + register[reg_2] },
  addi: -> (reg_1, reg_2, register) { register[reg_1] + reg_2 },
  mulr: -> (reg_1, reg_2, register) { register[reg_1] * register[reg_2] },
  muli: -> (reg_1, reg_2, register) { register[reg_1] * reg_2 },
  banr: -> (reg_1, reg_2, register) { register[reg_1] & register[reg_2] },
  bani: -> (reg_1, reg_2, register) { register[reg_1] & reg_2 },
  borr: -> (reg_1, reg_2, register) { register[reg_1] | register[reg_2] },
  bori: -> (reg_1, reg_2, register) { register[reg_1] | reg_2 },
  setr: -> (reg_1, reg_2, register) { register[reg_1] },
  seti: -> (reg_1, reg_2, register) { reg_1 },
  gtir: -> (reg_1, reg_2, register) { compare(reg_1, :>, register[reg_2]) },
  gtri: -> (reg_1, reg_2, register) { compare(register[reg_1], :>, reg_2) },
  gtrr: -> (reg_1, reg_2, register) { compare(register[reg_1], :>, register[reg_2]) },
  eqir: -> (reg_1, reg_2, register) { compare(reg_1, :==, register[reg_2]) },
  eqri: -> (reg_1, reg_2, register) { compare(register[reg_1], :==, reg_2) },
  eqrr: -> (reg_1, reg_2, register) { compare(register[reg_1], :==, register[reg_2]) },
}

def execute(register, instructions, &block)
  opcode, reg_1, reg_2, reg_storage = instructions
  value = yield(reg_1, reg_2, register)
  register[reg_storage] = value
  [opcode, register]
end

counts = funs.each_with_object({}) { |(k, _v), acc| acc[k] = [] }
matches_gt_three = 0

File.open('./input-one.txt').map(&:chomp).reject(&:empty?).each_slice(3) do |(before, instruction, after)|
  matches = 0
  before.sub!('Before: ', '')
  after.sub!('After:  ', '')
  funs.each do |(name, fun)|
    opcode, result = execute(JSON.parse(before), instruction.split(' ').map(&:to_i), &fun)

    if result == JSON.parse(after)
      counts[name] << opcode
      matches += 1
    end
    counts[name] << opcode if result == JSON.parse(after)
  end

  matches_gt_three += 1 if matches >= 3
end

p matches_gt_three

ops = counts.map { |k, v| [k, v.group_by(&:itself).keys] }.to_h
opcode_map = [nil] * 16

until opcode_map.none?(&:nil?)
  ops.each do |k, v|
    compare = v.each_with_object([]) { |(op, _), acc| acc << [op, opcode_map[op]] }.select { |vv| vv.last.nil? }
    if compare.size == 1
      opcode_map[compare.first.first] = k
      break
    end
  end
end

lines = File.open('./input-two.txt').map(&:chomp).
          map { |line| line.split(' ') }.
          map { |line| line.map(&:to_i) }

register = [0] * 4

lines.each do |instruction|
  fun = opcode_map[instruction.first]
  register = execute(register, instruction, &funs[fun]).last
end

p register.first
