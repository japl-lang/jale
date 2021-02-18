import ../plugin/defaults
import ../editor
import ../strutils
import ../templates
import ../multiline

import terminal
import os

eraseScreen()
setCursorPos(stdout, 0,0)
let e = newLineEditor()
if paramCount() > 0:
  let arg = paramStr(1)
  if fileExists(arg):
    e.content = readFile(arg).fromString()

var save = false
e.bindKey("ctrl+s"):
  e.finish()
  save = true

e.prompt = ""
e.populateDefaults(enterSubmits = false, shiftForVerticalMove = false)
let result = e.read()
if save and paramCount() > 0:
  writeFile(paramStr(1), result)

