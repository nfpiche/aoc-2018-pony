require 'pry'
require 'rspec'

def part_one(recipe_count)
  recipes = [3, 7]
  oi = 0
  ti = 1

  (recipe_count + 10).times do
    o = recipes[oi]
    t = recipes[ti]
    values = (o + t).digits.reverse
    values.each { |v| recipes.push(v) }

    oi = (o + oi + 1) % recipes.size
    ti = (t + ti + 1) % recipes.size
  end

  recipes[recipe_count..(recipe_count + 9)].join('')
end

def part_two(needle)
  recipes = [3, 7]
  oi = 0
  ti = 1

  loop do
    o = recipes[oi]
    t = recipes[ti]
    values = (o + t).digits.reverse
    recipes.concat(values)

    oi = (o + 1 + oi) % recipes.size
    ti = (t + 1 + ti) % recipes.size

    haystack = recipes.last(needle.size).join('')

    break if haystack == needle
  end

  recipes.size - needle.size
end

describe('part_one') do
  it('works') do
    expect(part_one(9)).to eql('5158916779')
    expect(part_one(5)).to eql('0124515891')
    expect(part_one(18)).to eql('9251071085')
    expect(part_one(2018)).to eql('5941429882')
    expect(part_one(505961)).to eql('9315164154')
  end
end

describe('part_two') do
  it('works1') do
    expect(part_two('51589')).to eql(9)
  end
  it('works2') do
    expect(part_two('01245')).to eql(5)
  end
  it('works3') do
    expect(part_two('92510')).to eql(18)
  end
  it('works4') do
    expect(part_two('59414')).to eql(2018)
  end
  it('works5') do
    expect(part_two('505961')).to eql(20231866)
  end
end
