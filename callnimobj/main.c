
#include "callnimobj.h"
#include <stdio.h>

int main(int argc, char *argv[])
{
    Foobar* foo = newFoobar(10.0, 30.0);
    printf("%f\n", FoobarDoIt(foo));
    FoobarFree(foo);

    return 0;
}
