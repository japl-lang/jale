# line.nim

import strformat

type
  Line* = ref object
    content: string

# getters/setters

proc content*(l: Line): string =
  l.content

proc `content=`*(l: Line, str: string) =
  l.content = str

# constructor

proc newLine*: Line =
  Line(content: "")

# methods

proc insert*(line: Line, str: string, pos: int) =
  if pos > line.content.high():
    line.content &= str
  elif pos == 0:
    line.content = str & line.content
  else:
    line.content = line.content[0..pos-1] & str & line.content[pos..line.content.high()]

proc delete*(line: Line, start: int, finish: int) =
  if start > finish or start < 0 or finish > line.content.high():
    raise newException(CatchableError, &"Invalid arguments for Line.delete: start {start}, finish {finish} for line of length {line.content.len()}")
  var result = ""
  if start > 0:
    result &= line.content[0..start-1]
  if finish < line.content.high():
    result &= line.content[finish+1..line.content.high()]
  line.content = result
