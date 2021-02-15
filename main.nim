import defaults
import tables
import editor
import strutils
import templates
import multiline
import event

var keep = true

let e = newLineEditor()

e.bindEvent(jeQuit):
  keep = false

e.bindKey('a'):
  echo "a has been pressed"

e.bindKey("ctrl+b"):
  echo "ctrl+b has been pressed"

e.prompt = "> "
e.populateDefaults()
while keep:
  let input = e.read()
  if input.contains("quit"):
    break
  else:
    echo "==="
    echo input
    echo "==="
  
