interface AocWrapper
  fun apply(path: String, env: Env) =>
    let part = try
      env.args(1)?
    else
      GeneralError("Please provide 1 or 2 for the part you are solving")
    end

    let result: (String | GeneralError) = match (part)
      | "1" => part_one(path, env)
      | "2" => part_two(path, env)
    else
      part
    end

    match (result)
      | let valid: String => env.out.print(valid)
      | let invalid: GeneralError => env.err.print(invalid.msg)
    end

  fun part_one(path: String, env: Env): (String | GeneralError)
  fun part_two(path: String, env: Env): (String | GeneralError)
