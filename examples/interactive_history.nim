import ../plugin/defaults
import ../plugin/history
import ../plugin/editor_history
import ../editor
import ../strutils
import ../templates

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

