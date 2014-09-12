import macros
import strutils
import sequtils

type  
  TTestCase = object of TObject
     fname : string
     ftests : seq[proc()]
  TTestSuite = object of TObject
     fname : string
     fcases: seq[ref TTestCase] not nil
  PTestCase = ref TTestCase
  PTestSuite = ref TTestSuite
  ETestFail* = object of ESynch

########################################

proc tokenize(str: string) : seq[string] =
  result = filter(str.split(" "), proc(x:string):bool = x!="")

proc runTests*(tc : PTestCase) =
  echo tc.fname, ":"
  for test in tc.ftests:
    try:
      test()
      echo "."
    except ETestFail:
      let
        e = getCurrentException()
        msg = getCurrentExceptionMsg()
        stackTrace = getStackTrace(e)
        stackLines = stackTrace.splitLines()
        lastStackFrame = stackLines[len(stackLines)-2]
        func = lastStackFrame.tokenize()[1]
      echo func & " : " & msg

proc addTest*(tc : PTestCase, closure : proc()) =
  tc.ftests.add(closure)

proc newTestCase*(name: string) : PTestCase =
  new(result)
  result.ftests = @[]
  result.fname = name

########################################

proc runTests*(ts : PTestSuite) =
  echo ts.fname, ":"
  for acase in ts.fcases:
    acase.runTests()

proc addTestCase*(ts: PTestSuite, tc: PTestCase) =
  ts.fcases.add(tc)

proc newTestSuite*(name: string) : PTestSuite =
  new(result)
  result.fcases = @[]
  result.fname = name

######################################

proc newTestFail*(msg) : ref ETestFail = 
  new(result)
  result.msg = msg

######################################

template ntassertTemplate(clause: expr, clauseStr: string) =
  if not clause:
    raise newTestFail("ntassert(" & clauseStr & ")")

macro ntassert*(clause: expr) : stmt = 
  result = getAST(ntassertTemplate(clause, toStrLit(clause)))

template ntasserteqTemplate(expected: expr, 
                            expectedStr: string, 
                            query: expr, 
                            queryStr: string) = 
  if expected != query:
    let 
      expectedVal : string = $(expected)
      actualVal : string = $(query)
    raise newTestFail("ntasserteq(" & expectedStr & 
                      ", " & queryStr & ") expected:" & 
                      expectedVal & " actual:" & actualVal)

macro ntasserteq*(expected: expr, query: expr) : stmt = 
  result = getAST(ntasserteqTemplate(expected, 
                                     toStrLit(expected), 
                                     query, 
                                     toStrLit(query)))
