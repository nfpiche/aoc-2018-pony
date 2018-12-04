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
  fun name(): String => "Example input yields 12"

  fun apply(h: TestHelper) =>
    let expectation: String = "12"
    match (DayTwo.part_one("./input-1.txt", h.env))
    | let result: String => h.assert_eq[String](result, expectation)
    | let err: GeneralError => h.fail(err.msg)
    end

class iso _TestInputTwo is UnitTest
  fun name(): String => "Example input yields fgij"

  fun apply(h: TestHelper) =>
    let expectation: String = "fgij"
    match (DayTwo.part_two("./input-2.txt", h.env))
    | let result: String => h.assert_eq[String](result, expectation)
    | let err: GeneralError => h.fail(err.msg)
    end
