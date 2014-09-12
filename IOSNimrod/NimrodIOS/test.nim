
type
  Foobar {.exportc.} = object
    fname : cstring
    fvalue : int

proc adder(x : int, y : int) : int {.exportc, cdecl.} =
    result = x + y
    
proc newFoobar(n : cstring, v : int) : ptr Foobar {.exportc, cdecl.} =
    result = create(Foobar)
    result.fname = n
    result.fvalue = v
    
proc name(self: ptr Foobar) : cstring {.exportc, cdecl.} =
    result = self.fname
    
proc freeFoobar(self: ptr Foobar) {.exportc, cdecl.} =
    free(self)
    
proc NRViewControllerDoSomething() {.importc: "NRViewControllerDoSomething".}

proc nimDoSomething() {.exportc, cdecl.} =
    NRViewControllerDoSomething()

