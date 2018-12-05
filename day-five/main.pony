use "collections"
use "time"
use "itertools"
use "regex"
use ".."

actor Main
  new create(env: Env) =>
    DayFive("./input.txt", env)

class DayFive is AocWrapper
  fun part_one(path: String, env: Env): (String | GeneralError) =>
    try
      let lines = FileHelper.get_lines(path, env)?

      match lines.size()
      | 1 =>
        for line in lines.values() do
          let first = line(0)?
          let cloned: String ref = line.clone()
          let stack: Array[U8] = []

          for c in cloned.values() do
            if stack.size() == 0 then
              stack.push(consume c)
            else
              let a = stack.pop()?
              if not _causes_reaction(a, c) then
                stack.push(consume a)
                stack.push(consume c)
              end
            end
          end

          return stack.size().string()
        end
      else
        return GeneralError("Should be only one line")
      end

      return GeneralError("Something weird")
    else
      GeneralError("Unable to open file at " + path)
    end

  fun _causes_reaction(a: U8, b: U8): Bool =>
    (((a - b) == 32) or ((b - a) == 32))

  fun part_two(path: String, env: Env): (String | GeneralError) =>
    "not implemented yet"
