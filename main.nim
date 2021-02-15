import defaults
import editor
import strutils
import templates

var keep = true

let e = newLineEditor()

e.bindEvent(jeQuit):
  keep = false

e.prompt = "> "
e.populateDefaults()
while keep:
  let input = e.read()
  echo "output:<" & input.replace("\n", "\\n") & ">"
  
