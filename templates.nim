import editor
import event
import keycodes
import tables

template bindKey*(editor: LineEditor, key: int, body: untyped) =
  proc action {.gensym.} =
    body
  editor.keystrokes.add(key, action)

template bindKey*(editor: LineEditor, key: char, body: untyped) =
  editor.bindKey(int(key)):
    body

template bindKey*(editor: LineEditor, key: string, body: untyped) =
  if not keysByName.hasKey(key):
    raise newException(Defect, "Invalid key " & key & ", it's not in the keycode table")
  editor.bindKey(keysByName[key]):
    body

template bindEvent*(editor: LineEditor, event: JaleEvent, body: untyped) =
  proc action {.gensym.} =
    body
  editor.events.add(event, action)
