
proc adder(x : int , y : int) : int {.exportc, cdecl.} =
  return x + y

echo adder(1, 2)

# proc printf(formatstr: cstring) {.importc: "printf", varargs,
#                                  header: "<stdio.h>".}

# printf("This works %s\n", "as expected")