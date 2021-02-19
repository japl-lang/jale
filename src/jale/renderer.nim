# renderer.nim
#
# a terminal renderer for readline-like libraries

import strutils
import uniterm

proc renderLine*(wr: var TermWriter, prompt: string, content: string, hscroll: int = 0) =
  wr.cr()
  var content = prompt & content
  if content.len() < wr.terminalWidth():
    content &= " ".repeat(wr.terminalWidth() - content.len())
  if content.len() > wr.terminalWidth():
    var lower = hscroll
    var upper = hscroll + wr.terminalWidth() - 1
    if upper > content.high():
      upper = content.high()
    content = content[lower..upper]
  wr &= content



