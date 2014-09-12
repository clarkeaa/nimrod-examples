import nimtests

var suite = newTestSuite("ASuite")
var mathcase = newTestCase("MathCase")

suite.addTestCase(mathcase)

proc testAssertFail() =
  ntassert(1+2 == 1)

proc testAssert() =
  ntassert(1 + 2 == 3)

proc testAssertEq() =
  ntasserteq(3, 1 + 2)

proc four() : int = 4

proc testAssertEqFail() =
  ntasserteq(3, four())

mathcase.addTest(testAssert)
mathcase.addTest(testAssertFail)
mathcase.addTest(testAssertEq)
mathcase.addTest(testAssertEqFail)

suite.runTests()