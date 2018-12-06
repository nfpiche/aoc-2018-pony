use "collections"
use "time"
use "itertools"
use "regex"
use ".."

actor Main
  new create(env: Env) =>
    DaySix("./input.txt", env)

class DaySix is AocWrapper
  fun part_one(path: String, env: Env): (String | GeneralError) =>
      "not yet implemented"

  fun part_two(path: String, env: Env): (String | GeneralError) =>
      "Not yet implemented"

class Point
  let x: USize
  let y: USize

  new create(x': USize, y': USize) =>
    x = x'
    y = y'

  fun distance(that: Point): USize =>
    ((x - that.x).abs()) + ((y - that.y).abs())
