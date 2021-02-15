# handy tool that prints out char codes when pressed

import terminal
import strutils

echo "Press 'ctrl+c' to quit"
echo "Press 'ctrl+a' to print a horizontal bar"
while true:
  let key = int(getch())
  if key == 3:
    break
  if key == 1:
    echo "=".repeat(terminalWidth())
  else:
    echo key
