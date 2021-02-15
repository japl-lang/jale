import strformat
import strutils
import tables
import terminal

import line
import multiline
import keycodes
import event
import renderer

type 
  JaleEvent* = enum
    jeKeypress, jeQuit

  LineEditor* = ref object
    content*: Multiline
    historyIndex*: int
    history: seq[Multiline]
    keystrokes*: Event[int]
    events*: Event[JaleEvent]
    prompt*: string
    lastKeystroke*: int
    finished*: bool
    rendered: int # how many lines were printed last full refresh

proc newLineEditor*: LineEditor =
  new(result)
  result.content = newMultiline()
  result.history = @[]
  result.history.add(result.content)
  result.historyIndex = 0
  result.keystrokes.new()
  result.events.new()
  result.prompt = ""
  result.rendered = 0
  
proc render(editor: LineEditor, line: int = -1, hscroll: bool = true) =
  var y = line
  if y == -1:
    y = editor.content.Y

  renderLine(
    (
      if y == 0:
        editor.prompt
      else:
        " ".repeat(editor.prompt.len())
    ),
    editor.content.getLine(y), 
    0
  )


proc fullRender(editor: LineEditor) =
  # from the current (proper) cursor pos, it draws the entire multiline prompt, then
  # moves cursor to current x,y
  for i in countup(0, editor.content.high()):
    editor.render(i, false)
#    if i <= editor.rendered:
    cursorDown(1)
#    else:
#      write stdout, "\n"
#      inc editor.rendered

proc restore(editor: LineEditor) =
  # from the line that's represented as y=0 it moves the cursor to editor.y
  # if it's at the bottom, it also scrolls enough
  # it's achieved by the right number of newlines
  # does not restore editor.x

  write stdout, "\n".repeat(editor.content.len())
  cursorUp(editor.content.len())
  editor.rendered = editor.content.len()

  if editor.content.Y == 0:
    return
  cursorDown(editor.content.Y)

proc moveCursorToEnd(editor: LineEditor) =
  # only called when read finished
  cursorDown(editor.content.high() - editor.content.Y)
  write stdout, "\n"

proc moveCursorToStart(editor: LineEditor, delta: int = 0) =
  if delta > 0:
    cursorUp(delta)

proc restoreCursor(editor: LineEditor) =
  if editor.content.Y > 0:
    cursorDown(editor.content.Y)

proc read*(editor: LineEditor): string =
#  write stdout, "\n"
  editor.restore()
  editor.fullRender()
  editor.restoreCursor()
  while not editor.finished:
    editor.render()
    setCursorXPos(editor.content.X + editor.prompt.len())
    let key = getKey()
    let preY = editor.content.Y
    editor.lastKeystroke = key
    editor.keystrokes.call(key)
    editor.events.call(jeKeypress)
    if preY != editor.content.Y:
      # redraw everything because y changed
      editor.moveCursorToStart(preY)
      editor.fullRender()
      editor.restoreCursor()

  editor.finished = false
  editor.moveCursorToEnd()
  
  return editor.content.getContent()
