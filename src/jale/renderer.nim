# renderer.nim
#
# a terminal renderer for readline-like libraries

import strutils
import terminal

proc renderLine*(prompt: string, content: string, hscroll: int = 0) =
  setCursorXPos(0)
  var content = prompt & content
  if content.len() < terminalWidth():
    content &= " ".repeat(terminalWidth() - content.len())
  if content.len() > terminalWidth():
    var lower = hscroll
    var upper = hscroll + terminalWidth() - 1
    if upper > content.high():
      upper = content.high()
    content = content[lower..upper]
  write stdout, content

