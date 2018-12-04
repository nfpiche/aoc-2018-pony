use "files"
use "itertools"
use "collections"
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
      | "1" => DayOne.part_one(_file_name, env)
      | "2" => DayOne.part_two(_file_name, env)
    else
      part
    end

    match (result)
      | let valid: String => env.out.print(valid)
      | let invalid: GeneralError => env.err.print(invalid.msg)
    end

primitive DayOne
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

