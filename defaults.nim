import editor
import keycodes
import multiline
import event
import tables
import templates

# default populate
proc defInsert(editor: LineEditor) =
  if editor.lastKeystroke > 31 and editor.lastKeystroke < 127:
    let ch = char(editor.lastKeystroke)
    editor.content.insert($ch)

proc defControl(editor: LineEditor) =
  block control:
    template check(key: string, blk: untyped) =
      if editor.lastKeystroke == keysByName[key]:
        blk
        break control
    check("left"):
      editor.content.left()
    check("right"):
      editor.content.right()
    check("up"):
      editor.content.up()
    check("down"):
      editor.content.down()
    check("backspace"):
      editor.content.backspace()
    check("delete"):
      editor.content.delete()
    check("enter"):
      if editor.content.Y() == editor.content.high() and editor.content.getLine(editor.content.high()) == "":
        editor.finish()
      else:
        editor.content.insertline()
    check("ctrl+c"):
      editor.finish()
      editor.events.call(jeQuit)
    check("ctrl+d"):
      if editor.content.getContent() == "":
        editor.finish()
        editor.events.call(jeQuit)

proc defLog(editor: LineEditor) =
  echo editor.lastKeystroke

proc populateDefaults*(editor: LineEditor) =
  editor.bindEvent(jeKeypress):
    editor.defInsert()
    editor.defControl()

