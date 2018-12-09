require 'rspec'

class DoublyLinkedNode
  attr_accessor :next, :prev
  attr_reader :value

  def initialize(v)
    @value = v
    @next = self
    @prev = self
  end

  def remove
    prev.next = @next
    @next.prev = prev
    value
  end

  def add(v)
    node = DoublyLinkedNode.new(v)
    node.prev = self
    node.next = @next
    @next.prev = node
    @next = node
  end

  def rotate(k)
    ret = self

    (k - 1).times { ret = ret.prev }
    ret
  end
end

def part_one(player_count, final_marble)
  players = [0] * player_count
  p_i = 0
  marbles = DoublyLinkedNode.new(0)

  1.upto(final_marble) do |marble|
    if (marble % 23).zero?
      marbles = marbles.rotate(7)
      last = marbles.prev.remove
      players[p_i] += marble + last
    else
      marbles = marbles.next.add(marble)
    end

    p_i = (p_i + 1) % players.size
  end

  players.max
end

describe('part_one') do
  it('returns 32 when there are 9 elves and marbles go up to 25') do
    expect(part_one(9, 25)).to eql(32)
  end

  it('returns 8317 when there are 10 elves and marbles go up to 1618') do
    expect(part_one(10, 1618)).to eql(8317)
  end

  it('returns 146373 when there are 13 elves and marbles go up to 7999') do
    expect(part_one(13, 7999)).to eql(146373)
  end

  it('returns 393229 when there are 441 elves and marbles go up to 71032') do
    expect(part_one(441, 71032)).to eql(393229)
  end

  it('returns 3273405195 when there are 441 elves and marbles go up to 7103200') do
    expect(part_one(441, (7103200))).to eql(3273405195)
  end
end
