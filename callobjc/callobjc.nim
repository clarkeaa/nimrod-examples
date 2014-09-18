
from strutils import split
from sequtils import zip
import macros

{.passC:"-objc-arc".}
{.passL:"-framework Foundation".}

template emitterTemplate(str: string) : expr =
  {.emit: str.}

macro emitter(str: string) : expr =
  result = getAST(emitterTemplate(str))

emitter("""
#import <stdio.h>
#import <Foundation/Foundation.h>
""")

template objcmsgTemplate(code:string) : stmt =
  emitter(code)

proc bracketMsg(code: expr) : string {.compileTime.} =
  result = "["
  for i in countup(1, len(code)-1):
    echo lispRepr(code[i])
    if i mod 2 == 1:
      if code[i].kind == nnkIntLit:
        result = result & $(code[i].intVal) & " "
      elif code[i].kind == nnkIdent:
        result = result & $(code[i].ident) & " "
      elif code[i].kind == nnkSym:
        result = result & "`" & $(code[i].symbol) & "` "
      else:
        assert(false)
    else:
      result = result & $(code[i].ident)
      if i < len(code)-1:
        result = result & ":"
  result.add("];")

proc isBracketCall(st: PNimrodNode) : bool {.compileTime.}=
  return st.kind == nnkBracketExpr and 
        len(st) > 0 and 
        st[0].kind == nnkIdent and 
        $(st[0].ident) == "o"

proc handleAsgn(st: PNimrodNode) : PNimrodNode {.compileTime.} =
  let rvalue : PNimrodNode = st[1]
  if isBracketCall(rvalue):
    let 
      lvalue : PNimrodNode = st[0]
      codeStr = $(lvalue.ident) & " = " & bracketMsg(rvalue)
    result = getAST(objcmsgTemplate(codeStr))
  else:
    result = st

macro objc(code: stmt) : stmt {.immediate.}=
  result = newNimNode(nnkStmtList)
  for st in code.children:
    if isBracketCall(st):
      result.add(getAST(objcmsgTemplate(bracketMsg(st))))
    elif st.kind == nnkAsgn:
      result.add(handleAsgn(st))
    else:
      result.add(st)

proc runobjc() =
  var 
    foo : pointer
    bar : pointer
    baz : pointer
    nsdesc : pointer
    desc : cstring
  objc:
    foo = o[NSMutableDictionary, alloc]
    foo = o[foo, init]
    bar = o[NSNumber, numberWithInt, 1234]
    baz = o[NSNumber, numberWithInt, 5678]
    o[foo, setObject, baz, forKey, bar]
    nsdesc = o[foo, description]
    desc = o[nsdesc, UTF8String]
  echo desc

runobjc()
