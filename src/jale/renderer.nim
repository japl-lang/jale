# renderer.nim
#
# a terminal renderer for readline-like libraries

import strutils
import terminal

proc renderLine*(prompt: string, text: string, hscroll: int = 0) =
  eraseLine()
  setCursorXPos(0)
  var lower = hscroll
  var upper = hscroll + terminalWidth() - prompt.len() - 1
  if upper > text.high():
    upper = text.high()
  if lower < -1:
    raise newException(Defect, "negative hscroll submitted to renderLine")
  if lower > text.high():
    write stdout, prompt
  else:
    let content = prompt & text[lower..upper]
    write stdout, content

