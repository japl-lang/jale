import unittest

import jale/event
import tables

test "can add procs to tests":
  let e = newEvent[int]()
  proc sayHi =
    echo "hi"

  proc sayHello =
    echo "hello"

  e.add(1, sayHi)
  e.add(2, sayHello)

  check e[1].len() == 1
  check e[2].len() == 1

test "can do closures with events":
  let e = newEvent[int]()
  var val = 4
  proc setVal =
    val = 2

  e.add(5, setVal)
  
  check val == 4
  e.call(1)
  check val == 4
  e.call(5)
  check val == 2

test "can remove from events":
  let e = newEvent[int]()
  var val = 10
  proc decVal =
    dec val

  e.add(1, decVal)
  e.add(2, decVal)
  e.add(3, decVal)

  e.call(5)
  check val == 10
  e.call(4)
  check val == 10
  e.call(3)
  check val == 9
  e.call(2)
  check val == 8
  e.call(1)
  check val == 7

  check e.remove(1, decVal) == true
  e.call(1)
  check val == 7
  e.call(2)
  check val == 6

test "can remove multiple at once":
  let e = newEvent[char]()
  var val = 8
  proc incVal =
    inc val

  e.add('a', incVal)
  e.add('a', incVal)

  e.call('a')
  check val == 10
  check e.remove('a', incVal) == true
  e.call('a')
  check val == 10

test "can remove non existent keys without crashing":
  let e = newEvent[uint8]()
  proc nothing =
    discard
  check e.remove(5'u8, nothing) == false

test "removal is selective for procs":
  let e = newEvent[string]()
  proc first =
    echo "1"
  proc second = 
    echo "2"
  e.add("key", first)
  e.add("key", second)
  check e.remove("key", first) == true
  check e["key"].len() == 1

test "purging":
  let e = newEvent[int]()
  proc nothing =
    discard

  e.add(1, nothing)
  e.add(1, nothing)
  e.add(2, nothing)
  e.add(1, nothing)
  
  check e[1].len() == 3
  e.purge(1)
  check e[1].len() == 0
  check e[2].len() == 1
