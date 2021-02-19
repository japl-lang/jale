import jale/plugin/defaults
import jale/plugin/history
import jale/plugin/editor_history
import jale/editor
import jale/templates

import strutils

var keep = true

let e = newLineEditor()

e.bindEvent(jeQuit):
  keep = false

e.prompt = "> "
e.populateDefaults()
let h = e.plugHistory()
e.bindHistory(h)

while keep:
  let input = e.read()
  echo "output:<" & input.replace("\n", "\\n") & ">"

