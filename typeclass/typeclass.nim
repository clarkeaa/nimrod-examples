type
  ATypeClass = generic x
    doit(x)
  Bar = object
    nameBar: string
  Foo = object
    nameFoo: string

proc printer(foo : ATypeClass) =
  foo.doit()

proc doit(bar: Bar) =
  echo(bar.nameBar)

proc doit(foo: Foo) =
  echo(foo.nameFoo)

var bard = Bar(nameBar: "this is a bar!")
printer(bard)

var bardfoo = Foo(nameFoo:"this is a foo!")
printer(bardfoo)


  