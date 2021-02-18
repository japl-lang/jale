import ../editor
import ../keycodes
import ../multiline
import ../event
import ../templates

import tables

proc bindInput*(editor: LineEditor) =
  editor.bindEvent(jeKeypress):
    if editor.lastKeystroke > 31 and editor.lastKeystroke < 127:
      let ch = char(editor.lastKeystroke)
      editor.content.insert($ch)

proc bindTerminate*(editor: LineEditor) =
  editor.bindKey("ctrl+c"):
    editor.quit()

  editor.bindKey("ctrl+d"):
    if editor.content.getContent() == "":
      editor.quit()


proc populateDefaults*(editor: LineEditor, enterSubmits = true, shiftForVerticalMove = true) =
  editor.bindInput()
  editor.bindTerminate()
  editor.bindKey("left"):
    editor.content.left()
  editor.bindKey("right"):
    editor.content.right()
  if shiftForVerticalMove:
    editor.bindKey("shiftup"):
      editor.content.up()
    editor.bindKey("shiftdown"):
      editor.content.down()
    editor.bindKey("ctrlpageup"):
      editor.content.vhome()
    editor.bindKey("ctrlpagedown"):
      editor.content.vend()
  else:
    editor.bindKey("up"):
      editor.content.up()
    editor.bindKey("down"):
      editor.content.down()
    editor.bindKey("pageup"):
      editor.content.vhome()
    editor.bindKey("pagedown"):
      editor.content.vend()
  editor.bindKey("home"):
    editor.content.home()
  editor.bindKey("end"):
    editor.content.`end`()
  editor.bindKey("backspace"):
    editor.content.backspace()
  editor.bindKey("delete"):
    editor.content.delete()
  if enterSubmits:
    editor.bindKey("ctrldown"):
      editor.content.enter()
    editor.bindKey("enter"):
      editor.finish()
  else:
    editor.bindKey("enter"):
      editor.content.enter()

