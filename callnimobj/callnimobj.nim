
type 
  Foobar {. exportc .} = object
    foo : float
    bar : float
  PFoobar = ptr Foobar

proc newFoobar(foo:float, bar:float) : PFoobar {. exportc .} =
  result = cast[PFoobar](alloc(sizeof(Foobar)))
  result.foo = foo
  result.bar = bar

proc FoobarDoIt(x : PFoobar) : float {. exportc .} =
  x.foo + x.bar

proc FoobarFree(x : PFoobar) {. exportc .} =
  dealloc(x)