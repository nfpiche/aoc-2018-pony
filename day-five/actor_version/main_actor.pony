use "collections"
use "itertools"
use "../.."

actor Main
  let env: Env
  var _min: USize = USize.max_value()
  var _count: U8 = 0

  new create(env': Env) =>
    env = env'
    try
      let lines = FileHelper.get_lines("../input.txt", env)?
      let line = lines(0)?
      start_messaging(line)
    else
      env.err.print("Couldn't do file things")
    end

  fun ref start_messaging(line: String) =>
    for skip in Range[U8](65, 91) do
      Calculator.calculate(this, line, skip)
    end

  be true_min() => env.out.print(_min.string())
  be next_min(check: USize) =>
    _min = _min.min(check)
    _count = _count + 1
    if _count == 26 then true_min() end

actor Calculator
  be calculate(receiver: Main, line: String, skip: U8) =>
    let formula: String ref = line.clone()
    let stack: Array[U8] = []

    for c in formula.values() do
      if ((c == skip) or (c == (skip + 32))) then continue end

      if stack.size() == 0 then
        stack.push(consume c)
      else
        let a = try stack.pop()? else 0 end

        if not _causes_reaction(a, c) then
          stack.push(consume a)
          stack.push(consume c)
        end
      end
    end

    receiver.next_min(stack.size())

  fun _causes_reaction(a: U8, b: U8): Bool =>
    (((a - b) == 32) or ((b - a) == 32))
