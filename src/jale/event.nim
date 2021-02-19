# event.nim

import tables

type
  Event*[T] = TableRef[T, seq[proc ()]]

proc newEvent*[T]: Event[T] =
  new(result)

proc call*[T](evt: Event[T], key: T) =
  if evt.hasKey(key):
    for callback in evt[key]:
      callback()

proc add*[T](event: Event[T], key: T, callback: proc) =
  if not event.hasKey(key):
    event[key] = @[]
  event[key].add(callback)

proc remove*[T](event: Event[T], key: T, callback: proc): bool =
  result = false
  if event.hasKey(key):
    var i = 0
    while i < event[key].len():
      if event[key][i] == callback:
        event[key].del(i)
        result = true
      else:
        inc i

proc purge*[T](event: Event[T], key: T) =
  if event.hasKey(key):
    event[key] = @[]

