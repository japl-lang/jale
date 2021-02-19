# handy tool that prints out char codes when pressed

import jale/uniterm
import jale/keycodes
import strutils
import terminal
import os
import tables

echo "Press 'ctrl+c' to quit"
echo "Press 'ctrl+a' to print a horizontal bar"

var escape = false
if paramCount() > 0 and paramStr(1) == "esc":
  escape = true

while true:

  let key = if escape: getKey() else: int(uniGetchr())
  if key == 3:
    break
  if key == 1:
    echo "=".repeat(terminalWidth())
  else:
    if keysById.hasKey(key):
      echo keysById[key]
    else:
      echo key
