# multiline.nim

import line

type
  Multiline* = ref object
    lines: seq[Line]
    x,y: int

# getters/setters

proc X*(ml: Multiline): int =
  ml.x

proc Y*(ml: Multiline): int =
  ml.y

# constructor

proc newMultiline*: Multiline =
  new(result)
  result.lines = @[]
  result.lines.add(newLine())
  result.x = 0
  result.y = 0

# methods

proc lineLen*(ml: Multiline): int =
  ml.lines[ml.y].content.len()

proc lineHigh*(ml: Multiline): int =
  ml.lineLen() - 1

proc len*(ml: Multiline): int =
  ml.lines.len()

proc high*(ml: Multiline): int =
  ml.lines.high()

proc left*(ml: Multiline) =
  if ml.x > 0:
    dec ml.x

proc right*(ml: Multiline) =
  if ml.x < ml.lineLen():
    inc ml.x

proc up*(ml: Multiline) =
  if ml.y > 0:
    dec ml.y
  if ml.x > ml.lineLen():
    ml.x = ml.lineLen()

proc down*(ml: Multiline) =
  if ml.y < ml.lines.high():
    inc ml.y
  if ml.x > ml.lineLen():
    ml.x = ml.lineLen()

proc insert*(ml: Multiline, str: string) =
  ml.lines[ml.y].insert(str, ml.x)
  ml.x += str.len()

proc delete*(ml: Multiline) =
  if ml.x < ml.lineLen():
    ml.lines[ml.y].delete(ml.x, ml.x)

proc backspace*(ml: Multiline) =
  if ml.x > 0:
    ml.lines[ml.y].delete(ml.x - 1, ml.x - 1)
    dec ml.x

proc insertline*(ml: Multiline) =
  # TODO split line support
  if ml.y == ml.lines.high():
    ml.lines.add(newLine())
  else:
    ml.lines.insert(newLine(), ml.y + 1)
  inc ml.y
  ml.x = 0


proc clearline*(ml: Multiline) =
  ml.lines[ml.y].content = ""

proc removeline*(ml: Multiline) =
  ml.lines.delete(ml.y)
  if ml.lines.len() == 0:
    ml.lines.add(newLine())
  if ml.y > ml.lines.high():
    dec ml.y

proc getLine*(ml: Multiline, line: int = -1): string =
  if line == -1:
    ml.lines[ml.y].content
  else:
    if line >= 0 and line <= ml.lines.high():
      ml.lines[line].content
    else:
      ""

proc getContent*(ml: Multiline): string =
  for line in ml.lines:
    result &= line.content & "\n"
  result[0..result.high()-1] # cut finishing newline

