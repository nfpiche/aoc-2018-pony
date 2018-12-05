use "collections"
use "itertools"
use "regex"
use ".."

actor Main
  new create(env: Env) =>
    DayFour("./input.txt", env)

class Guard
  let id: I64
  let _env: Env
  var _sleep_amount: I64
  var _full_history: Map[I64, I64]
  var _most_common_sleep_time: (I64, I64)

  new create(id': I64, env: Env) =>
    id = id'
    _env = env
    _sleep_amount = 0
    _most_common_sleep_time = (0, 0)
    _full_history = _full_history.create()

  fun ref sleep(sleep_time: I64, wake_time: I64) =>
    let current_sleep_amount = (wake_time - sleep_time)
    _sleep_amount = _sleep_amount + (wake_time - sleep_time)
    _update_full_history(sleep_time, wake_time)

  fun ref _update_full_history(sleep_time: I64, wake_time: I64) =>
    for i in Range[I64](sleep_time, wake_time) do
      let count: I64 = try _full_history.upsert(i, 1, {(a, b) => a + b})? else 0 end

      if count > _most_common_sleep_time._1 then
        _most_common_sleep_time = (count, i)
      end
    end

  fun most_common_sleep_count(): I64 => _most_common_sleep_time._1
  fun most_common_sleep_time(): I64 => _most_common_sleep_time._2
  fun sleep_amount(): I64 => _sleep_amount

class DayFour is AocWrapper
  fun _make_guards(path: String, env: Env): MapIs[I64, Guard] ? =>
      let lines = FileHelper.get_lines(path, env)?.clone()
      let sorted = Sort[Array[String], String](lines)
      let guards = MapIs[I64, Guard]
      var guard_id: I64 = 0
      var sleep_time: I64 = 0
      var wake_time: I64 = 0

      for line in sorted.values() do
        let split_string = line.split("]")
        let timestamp = try split_string(0)? else "" end
        let message = try split_string(1)? else "" end
        let minutes = _get_minutes(timestamp)

        match (message, minutes)
        | (" falls asleep", let valid: I64) => sleep_time = valid
        | (" wakes up", let valid: I64) =>
          try
            guards.upsert(
              guard_id,
              Guard(guard_id, env).>sleep(sleep_time, valid),
              {(g, _) => g.>sleep(sleep_time, valid)}
            )?
          end
        | (_, _) => guard_id = _get_guard_id(message)
        end
      end

      guards

  fun part_one(path: String, env: Env): (String | GeneralError) =>
    try
      let guards = _make_guards(path, env)?
      var max_sleep = I64.min_value()
      var max_guard: Guard = Guard(-1, env)

      for guard in guards.values() do
        if guard.sleep_amount() > max_sleep then
          max_sleep = guard.sleep_amount()
          max_guard = guard
        end
      end

      (max_guard.id * max_guard.most_common_sleep_time()).string()
    else
      GeneralError("Cannot open file at " + path)
    end

  fun part_two(path: String, env: Env): (String | GeneralError) =>
    try
      let guards = _make_guards(path, env)?

      var max_sleep = I64.min_value()
      var max_guard: Guard = Guard(-1, env)

      for guard in guards.values() do
        if guard.most_common_sleep_count() > max_sleep then
          max_sleep = guard.most_common_sleep_count()
          max_guard = guard
        end
      end

      (max_guard.id * max_guard.most_common_sleep_time()).string()
    else
      GeneralError("Cannot open file at " + path)
    end

  fun _get_minutes(timestamp: String): I64 =>
    try
      let minute_regex: Regex = Regex(".*\\d\\d:(\\d+)")?
      let match_line = minute_regex(timestamp)?
      match_line(1)?.i64()?
    else
      10000000
    end

  fun _get_guard_id(message: String): I64 =>
    try
      let guard_regex: Regex = Regex("Guard #(\\d+).*")?
      let match_line = guard_regex(message)?
      match_line(1)?.i64()?
    else
      1000000000
    end
