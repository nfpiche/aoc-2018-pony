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
    try
      let lines = FileHelper.get_lines(path, env)?
      let data: PointData = PointData(lines)?

      let top_x: USize = data.max_x()
      let top_y: USize = data.max_y()

      for x in Range[USize](0, 499) do
        for y in Range[USize](0, 499) do
          var min_point = Point(0, 0)
          var min_distance: USize = 999
          var skip = false

          for point in data.points().values() do
            let other_point = Point(x, y)
            let check_distance = point.distance(other_point)

            if check_distance < min_distance then
              min_point = consume point
              min_distance = consume check_distance
              skip = false
            elseif check_distance == min_distance then
              skip = true
            end
          end

          if (x == 0) or (y == 0) or (x == top_x) or (y == top_y) then
            data.add_infinite(min_point)
          end

          if not skip then
            data.add_count_for(min_point)?
          end
        end
      end

      var true_max: I64 = I64.min_value()

      for point in data.points().values() do
        if not data.infinites.contains(point.key) then
          let v = data.count_for(point)
          true_max = true_max.max(v)
        end
      end

      true_max.string()
    else
      GeneralError("Unable to open file")
    end

  fun part_two(path: String, env: Env): (String | GeneralError) =>
      "Not yet implemented"

class PointData
  let _point_counts: Map[String, I64]
  let _points: Array[Point]
  let _lines: Array[String]
  let infinites: Set[String]
  var _max_x: USize
  var _max_y: USize

  new create(lines: Array[String] val) ? =>
    _max_x = USize.min_value()
    _max_y = USize.min_value()
    _point_counts = _point_counts.create()
    _points = []
    infinites = infinites.create()
    _lines = lines.clone()
    _fill_points()?

  fun max_x(): USize => _max_x
  fun max_y(): USize => _max_y
  fun points(): this->Array[Point] => _points
  fun count_for(point: Point): I64 => try _point_counts(point.key)? else I64.min_value() end

  fun ref add_infinite(point: Point) =>
    infinites.set(point.key)

  fun ref add_count_for(point: Point) ? =>
    _point_counts.upsert(point.key, 1, {(a, b) => a + b})?

  fun ref _fill_points() ? =>
    for line in _lines.values() do
      let xy = line.split_by(", ")
      let x: USize = try xy(0)?.usize()? else -1 end
      let y: USize = try xy(1)?.usize()? else -1 end
      let point = Point(x, y)

      _point_counts.insert(point.key, I64(0))?
      _points.push(consume point)
      _calculate_next_maxes(x, y)
    end

  fun ref _calculate_next_maxes(x: USize, y: USize) =>
    _max_x = _max_x.max(x)
    _max_y = _max_y.max(y)

class Point
  let x: USize
  let y: USize
  let key: String val

  new create(x': USize, y': USize) =>
    x = x'
    y = y'
    key = x.string() + "," + y.string()

  fun distance(that: Point): USize =>
    ((x - that.x).abs()) + ((y - that.y).abs())
