type
  LinkedList[T] = object
    data: T
    next: ref LinkedList[T]

proc cons[T](ll : ref LinkedList[T], newData : T) : 
  ref LinkedList[T] =
  return (ref LinkedList[T])(data: newData, next: ll)

proc foreach[T](ll : ref LinkedList[T], fun : proc(t:T)) =
  if ll != nil:
    fun(ll.data)
    foreach(ll.next, fun)

var ll : ref LinkedList[int] = nil
ll = cons(ll, 1)
ll = cons(ll, 2)
ll = cons(ll, 3)

foreach(ll, proc(x:int) = echo x)