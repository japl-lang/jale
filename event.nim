# event.nim

import tables

type
  Event*[T] = TableRef[T, seq[proc ()]]

proc call*[T](evt: Event[T], key: T) =
  if evt.hasKey(key):
    for callback in evt[key]:
      callback()

proc add*[T](event: Event[T], key: T, callback: proc) =
  if not event.hasKey(key):
    event[key] = @[]
  event[key].add(callback)

