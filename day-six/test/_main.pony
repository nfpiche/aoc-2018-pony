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

class iso _TestInputOne is UnitTest
  fun name(): String => "Example yields 17"

  fun apply(h: TestHelper) =>
    let expectation: String = "17"
    match (DaySix.part_one("./input.txt", h.env))
    | let result: String => h.assert_eq[String](result, expectation)
    | let err: GeneralError => h.fail(err.msg)
    end

