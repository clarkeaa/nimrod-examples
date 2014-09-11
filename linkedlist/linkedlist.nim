type
  LinkedList[T] = object
    data: T
    next: ref LinkedList[T]

proc cons[T](ll : ref LinkedList[T], newData : T) : 
  ref LinkedList[T] =
  return (ref LinkedList[T])(data: newData, next: ll)

proc foreach[T](ll : ref LinkedList[T], func : proc(t:T)) =
  if ll != nil:
    func(ll.data)
    foreach(ll.next, func)

var ll : ref LinkedList[int] = nil
ll = cons(ll, 1)
ll = cons(ll, 2)
ll = cons(ll, 3)

foreach(ll, proc(x:int) = echo x)