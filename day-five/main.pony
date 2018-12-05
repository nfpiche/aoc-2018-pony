use "collections"
use "time"
use "itertools"
use "regex"
use ".."

actor Main
  new create(env: Env) =>
    DayFive("./input.txt", env)

class DayFive is AocWrapper
  fun _get_size(formula: String): String ? =>
    let cloned: String ref = formula.clone()
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

    stack.size().string()

  fun part_one(path: String, env: Env): (String | GeneralError) =>
    try
      let lines = FileHelper.get_lines(path, env)?

      match lines.size()
      | 1 =>
        let line = lines(0)?
        return _get_size(line)?
      else
        return GeneralError("Should be only one line")
      end
    else
      GeneralError("Unable to open file at " + path)
    end

  fun _causes_reaction(a: U8, b: U8): Bool =>
    (((a - b) == 32) or ((b - a) == 32))

  fun part_two(path: String, env: Env): (String | GeneralError) =>
    try
      let lines = FileHelper.get_lines(path, env)?
      let line = lines(0)?
      let formula: String ref = line.clone()
      var min: USize = USize.max_value()

      for i in Range[U8](65, 91) do
        let stack: Array[U8] = []
        for c in formula.values() do
          if ((c == i) or (c == (i +32))) then continue end

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

        min = min.min(stack.size())
      end

      min.string()
    else
      GeneralError("Unable to open file at " + path)
    end
