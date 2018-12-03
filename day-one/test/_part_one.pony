use "ponytest"
use ".."

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  new make() =>
    None

  fun tag tests(test: PonyTest) =>
    test(_TestInputOneOne)
    test(_TestInputOneTwo)
    test(_TestInputOneThree)
    test(_TestInputTwoOne)
    test(_TestInputTwoTwo)
    test(_TestInputTwoThree)
    test(_TestInputTwoFour)

class iso _TestInputOneOne is UnitTest
  fun name(): String => "+1 +1 +1 yields 3"

  fun apply(h: TestHelper) =>
    let expectation: String = "3"
    match (DayOne.part_one("./input-1-1.txt", h.env))
    | let result: String => h.assert_eq[String](result, expectation)
    | let err: GeneralError => h.fail(err.msg)
    end

class iso _TestInputOneTwo is UnitTest
  fun name(): String => "+1 +1 -2 yields 0"

  fun apply(h: TestHelper) =>
    let expectation: String = "0"
    match (DayOne.part_one("./input-1-2.txt", h.env))
    | let result: String => h.assert_eq[String](result, expectation)
    | let err: GeneralError => h.fail(err.msg)
    end

class iso _TestInputOneThree is UnitTest
  fun name(): String => "-1 -2 -3 yields -6"

  fun apply(h: TestHelper) =>
    let expectation: String = "-6"
    match (DayOne.part_one("./input-1-3.txt", h.env))
    | let result: String => h.assert_eq[String](result, expectation)
    | let err: GeneralError => h.fail(err.msg)
    end

class iso _TestInputTwoOne is UnitTest
  fun name(): String => "+1 -1 yields 0"

  fun apply(h: TestHelper) =>
    let expectation: String = "0"
    match (DayOne.part_two("./input-2-1.txt", h.env))
    | let result: String => h.assert_eq[String](result, expectation)
    | let err: GeneralError => h.fail(err.msg)
    end

class iso _TestInputTwoTwo is UnitTest
  fun name(): String => "+3 +3 +4 -2 -4 yields 10"

  fun apply(h: TestHelper) =>
    let expectation: String = "10"
    match (DayOne.part_two("./input-2-2.txt", h.env))
    | let result: String => h.assert_eq[String](result, expectation)
    | let err: GeneralError => h.fail(err.msg)
    end

class iso _TestInputTwoThree is UnitTest
  fun name(): String => "-6 +3 +8 +5 -6 yields 5"

  fun apply(h: TestHelper) =>
    let expectation: String = "5"
    match (DayOne.part_two("./input-2-3.txt", h.env))
    | let result: String => h.assert_eq[String](result, expectation)
    | let err: GeneralError => h.fail(err.msg)
    end

class iso _TestInputTwoFour is UnitTest
  fun name(): String => "+7 +7 -2 -7 -4 yields 14"

  fun apply(h: TestHelper) =>
    let expectation: String = "14"
    match (DayOne.part_two("./input-2-4.txt", h.env))
    | let result: String => h.assert_eq[String](result, expectation)
    | let err: GeneralError => h.fail(err.msg)
    end
