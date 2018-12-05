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
          try
            var formula = line.clone()
            var a = USize(0)
            var b = USize(1)

            repeat
              let first_character = formula(a)?
              let second_character = formula(b)?

              if _causes_reaction(first_character, second_character) then
                formula.cut_in_place(ISize.from[USize](a), ISize.from[USize](b + 1))
                a = if a == 0 then 0 else a - 1 end
                b = if b == 1 then 1 else b - 1 end
              else
                a = a + 1
                b = b + 1
              end
            until b >= formula.size() end

            return formula.size().string()
          else
            return GeneralError("Unexpected error occurred")
          end
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
