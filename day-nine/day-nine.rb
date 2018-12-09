require 'rspec'
def part_one(player_count, final_marble)
  players = [0] * player_count
  p_i = 3
  i = 1
  placed = [0, 2, 1, 3]

  s = Time.now
  4.upto(final_marble) do |m|
    if (m % 23).zero?
      pull_i = i - 9

      if pull_i < 0
        pull_i = (pull_i + placed.size).abs
      end

      players[p_i] += (m + placed[pull_i])
      placed.delete_at(pull_i)
      i = pull_i + 2
    else
      next_insert = i > placed.size ? (i / placed.size) : i
      placed.insert(next_insert, m)
      i = next_insert + 2
    end

    p_i = (p_i + 1) % players.size
    if (m % 100_000).zero?
      e = Time.now
      p "Marble number: [#{m}], elapsed time is #{e - s} second"
    end
  end

  players.max
end

describe('part_one') do
  xit('returns 32 when there are 9 elves and marbles go up to 25') do
    expect(part_one(9, 25)).to eql(32)
  end

  xit('returns 8317 when there are 10 elves and marbles go up to 1618') do
    expect(part_one(10, 1618)).to eql(8317)
  end

  xit('returns 146373 when there are 13 elves and marbles go up to 7999') do
    expect(part_one(13, 7999)).to eql(146373)
  end

  xit('returns 393229 when there are 441 elves and marbles go up to 71032') do
    expect(part_one(441, 71032)).to eql(393229)
  end

  it('returns 3273405195 when there are 441 elves and marbles go up to 7103200') do
    expect(part_one(441, (7103200))).to eql(3273405195)
  end
end
