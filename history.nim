# history.nim

import multiline

type HistoryElement* = ref object
  original*: Multiline
  current*: Multiline

type History* = ref object
  elements: seq[HistoryElement]
  index: int
  lowestTouchedIndex: int

proc newHistoryElement*(og: Multiline): HistoryElement =
  new(result)
  result.original = og
  new(result.current) # TODO deepcopy

proc delta*(h: History, amt: int): Multiline =
  discard # move up/down in history and return reference to current
  # also update lowest touched index

proc clean*(h: History) =
  discard # restore originals to current
  # from lowest touched index to the top

proc save*(h: History, path: string) =
  discard # convert it to string, save

proc loadHistory*(path: string): History =
  discard # create new history from file

