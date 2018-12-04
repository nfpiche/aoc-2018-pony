use "files"
use "itertools"
use "collections"
use ".."

actor Main
  new create(env: Env) =>
    DayOne("./input.txt", env)

class DayOne is AocWrapper
  fun _maybe_add(acc: I64, next: String): (I64 | GeneralError) =>
    try
      acc + next.clone().>remove("+").i64()?
    else
      GeneralError("Unable to convert " + next)
    end

  fun part_one(path: String, env: Env): (String | GeneralError) =>
    try
      let lines = FileHelper.get_lines(path, env)?
      var acc: I64 = 0

      for line in Iter[String](lines.values()) do
        match DayOne._maybe_add(acc, line)
          | let next: I64 => acc = next
          | let invalid: GeneralError => return invalid
        end
      end

      acc.string()
    else
      GeneralError("Unable to get lines from file at " + path)
    end


  fun part_two(path: String, env: Env): (String | GeneralError) =>
    try
      let lines = FileHelper.get_lines(path, env)?
      var acc: I64 = 0
      let occurences = SetIs[I64]
      occurences.set(0)

      for line in Iter[String](lines.values()).cycle() do
        match DayOne._maybe_add(acc, line)
          | let next: I64 =>
            acc = next
            if occurences.contains(acc) then
              return acc.string()
            else
              occurences.set(acc)
            end
          | let invalid: GeneralError => invalid
        end
      end

      GeneralError("You'll never actually see me")
    else
      GeneralError("Unable to get lines from file at " + path)
    end

