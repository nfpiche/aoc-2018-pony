use "collections"
use "itertools"
use "regex"
use ".."

actor Main
  new create(env: Env) =>
    DayThree("./input.txt", env)

class DayThree is AocWrapper
  fun _make_key(x: I64, y: I64): String =>
    x.string() + "," + y.string()

  fun part_one(path: String, env: Env): (String | GeneralError) =>
    try
      let lines = FileHelper.get_lines(path, env)?
      let visited_coords = Map[String, I64]
      var overlap: I64 = 0

      for line in lines.values() do
        let values = _extract_values(line)
        match values
        | None => return GeneralError("Unable to parse out values")
        | (let id: I64, let x: I64, let y: I64, let w: I64, let h: I64) =>
          for i in Range[I64](x, x + w) do
            for j in Range[I64](y, y + h) do
              let key = _make_key(i, j)
              try
                if visited_coords.upsert(key, 1, {(a, b) => a + b})? == 2 then
                  overlap = overlap + 1
                end
              end
            end
          end
        end
      end

      overlap.string()
    else
      GeneralError("Cannot open file at " + path)
    end

  fun part_two(path: String, env: Env): (String | GeneralError) =>
    try
      let lines = FileHelper.get_lines(path, env)?
      let ids = SetIs[I64]
      let visited_coords = Map[String, SetIs[I64]]

      for line in lines.values() do
        let values = _extract_values(line)
        match values
        | None => return GeneralError("Unable to parse out values")
        | (let id: I64, let x: I64, let y: I64, let w: I64, let h: I64) =>
          ids.set(id)
          for i in Range[I64](x, x + w) do
            for j in Range[I64](y, y + h) do
              let key = _make_key(i, j)
              try visited_coords.upsert(key, SetIs[I64].>set(id), {(s, _v) => s.>set(id)})? end
            end
          end
        end
      end

      for v in visited_coords.values() do
        for id in v.values() do
          if v.size() > 1 then
            ids.unset(id)
          end

          if ids.size() == 1 then
            for vv in ids.values() do
              return vv.string()
            end
          end
        end
      end

      GeneralError("Found no singular ids")
    else
      GeneralError("Cannot open file at " + path)
    end

  fun _extract_values(line: String): ((I64, I64, I64, I64, I64) | None) =>
    try
      let line_regex = Regex("#(\\d+) @ (\\d+),(\\d+): (\\d+)x(\\d+).*")?
      let match_line = line_regex(line)?
      (
        match_line(1)?.i64()?,
        match_line(2)?.i64()?,
        match_line(3)?.i64()?,
        match_line(4)?.i64()?,
        match_line(5)?.i64()?
      )
    end
