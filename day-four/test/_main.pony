use "ponytest"
use ".."
use "../.."

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  new make() =>
    None

  fun tag tests(test: PonyTest) =>
    test(_TestInputOne)
    test(_TestInputTwo)

class iso _TestInputOne is UnitTest
  fun name(): String => "Example input yields 240"

  fun apply(h: TestHelper) =>
    let expectation: String = "240"
    match (DayFour.part_one("./input.txt", h.env))
    | let result: String => h.assert_eq[String](result, expectation)
    | let err: GeneralError => h.fail(err.msg)
    end

class iso _TestInputTwo is UnitTest
  fun name(): String => "Example input yields 4455"

  fun apply(h: TestHelper) =>
    let expectation: String = "4455"
    match (DayFour.part_two("./input.txt", h.env))
    | let result: String => h.assert_eq[String](result, expectation)
    | let err: GeneralError => h.fail(err.msg)
    end
