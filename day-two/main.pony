use "collections"
use "itertools"
use ".."

actor Main
  let _file_name: String = "./input.txt"

  new create(env: Env) =>
    let part = try
      env.args(1)?
    else
      GeneralError("Please provide 1 or 2 for the part you are solving")
    end

    let result: (String | GeneralError) = match (part)
    | "1" => DayTwo.part_one(_file_name, env)
    | "2" => DayTwo.part_two(_file_name, env)
    else
      part
    end

    match (result)
    | let valid: String => env.out.print(valid)
    | let invalid: GeneralError => env.err.print(invalid.msg)
    end

primitive DayTwo
  fun part_one(path: String, env: Env): (String | GeneralError) =>
    try
      let lines = FileHelper.get_lines(path, env)?
      var twosCount: I64 = 0
      var threesCount: I64 = 0

      for line in lines.values() do
        let histogram = MapIs[U8, I64]
        var twos: I64 = 0
        var threes: I64 = 0

        for c in line.values() do
          try histogram.upsert(c, 1, {(a, b) => a + b})? end
        end

        for (_, v) in histogram.pairs() do
          match v
          | 2 => twos = 1
          | 3 => threes = 1
          end
        end

        twosCount = twosCount + twos
        threesCount = twosCount + threes
      end

      (twosCount * threesCount).string()
    else
      GeneralError("Cannot open file at " + path)
    end

  fun part_two(path: String, env: Env): (String | GeneralError) =>
    try
      let lines = FileHelper.get_lines(path, env)?

      for line in lines.values() do
        for next in lines.values() do
          (let one_different, let diffed_string) = _is_one_different(line, next)

          if one_different then return diffed_string end
        end
      end

      GeneralError("No one diffed strings found")
    else
      GeneralError("Cannot open file at " + path)
    end

  fun _is_one_different(a: String, b: String): (Bool, String) =>
    let size = a.size()

    let diffed = Iter[U8](a.values()).zip[U8](b.values()).fold[String]("", {(acc, pair) =>
      (let c, let d) = pair
      if c == d then
        acc + String.from_utf32(c.u32())
      else
        acc
      end
    })

    ((size - 1) == diffed.size(), diffed)