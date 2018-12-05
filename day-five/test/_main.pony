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
    test(_TestInputThree)

class iso _TestInputOne is UnitTest
  fun name(): String => "dabAcCaCBAcCcaDA yields 10"

  fun apply(h: TestHelper) =>
    let expectation: String = "10"
    match (DayFive.part_one("./input.txt", h.env))
    | let result: String => h.assert_eq[String](result, expectation)
    | let err: GeneralError => h.fail(err.msg)
    end

class iso _TestInputTwo is UnitTest
  fun name(): String => "yields 5"

  fun apply(h: TestHelper) =>
    let expectation: String = "1"
    match (DayFive.part_one("./input2.txt", h.env))
    | let result: String => h.assert_eq[String](result, expectation)
    | let err: GeneralError => h.fail(err.msg)
    end

class iso _TestInputThree is UnitTest
  fun name(): String => "Example input yields 4"

  fun apply(h: TestHelper) =>
    let expectation: String = "4"
    match (DayFive.part_two("./input.txt", h.env))
    | let result: String => h.assert_eq[String](result, expectation)
    | let err: GeneralError => h.fail(err.msg)
    end
