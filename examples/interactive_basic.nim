import jale/plugin/defaults
import jale/editor
import jale/templates

import strutils

var keep = true

let e = newLineEditor()

e.bindEvent(jeQuit):
  keep = false

e.prompt = "> "
e.populateDefaults()

while keep:
  let input = e.read()
  echo "output:<" & input.replace("\n", "\\n") & ">"

