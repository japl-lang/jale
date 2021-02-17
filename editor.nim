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
    jeKeypress, jeQuit, jeFinish, jeHistoryChange

  LineEditor* = ref object
    content*: Multiline
    historyIndex*: int # TODO to be private
    history*: seq[Multiline] # TODO to be private
    keystrokes*: Event[int]
    events*: Event[JaleEvent]
    prompt*: string
    lastKeystroke*: int
    finished: bool
    rendered: int # how many lines were printed last full refresh

# getter/setter sorts

proc unfinish*(le: LineEditor) =
  le.finished = false

proc finish*(le: LineEditor) =
  le.finished = true
  # can be overwritten to false, inside the event
  le.events.call(jeFinish)

# constructor

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
  
# priv/pub methods

proc historyMove*(editor: LineEditor, delta: int) =
  # broken behaviour: history should not be modified, it should clone
  # the modified one that is eventually submitted and add it to the end
  # TODO
  if editor.historyIndex + delta < 0:
    editor.content = editor.history[0]
    editor.historyIndex = 0
  elif editor.historyIndex + delta >= editor.history.high():
    editor.content = editor.history[editor.history.high()]
    editor.historyIndex = editor.history.high()
  else:
    editor.content = editor.history[editor.historyIndex + delta]
    editor.historyIndex += delta
  editor.events.call(jeHistoryChange)


proc reset(editor: LineEditor) =
  editor.unfinish()
  editor.rendered = 0

proc flush*(editor: LineEditor) =
  # kinda like reset, it moves the current element one down in history
  # and adds a new one
  editor.reset()
  editor.content = newMultiline()
  editor.history.add(editor.content)
  editor.historyIndex = editor.history.high()

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

proc clearLine =
  write stdout, "\r" & " ".repeat(terminalWidth())

proc fullRender(editor: LineEditor) =
  # from the top cursor pos, it draws the entire multiline prompt, then
  # moves cursor to current y
  for i in countup(0, editor.content.high()):
    editor.render(i, false)
    if i < editor.rendered:
      cursorDown(1)
    else:
      write stdout, "\n"
      inc editor.rendered
      
  var extraup = 0
  while editor.content.len() < editor.rendered:
    clearLine()
    cursorDown(1)
    dec editor.rendered
    inc extraup

  cursorUp(editor.content.len() - editor.content.Y + extraup)

proc moveCursorToEnd(editor: LineEditor) =
  # only called when read finished
  if editor.content.high() > editor.content.Y:
    cursorDown(editor.content.high() - editor.content.Y)
  write stdout, "\n"

# TODO don't use globals, but allow for event removal
var histchange = false
proc changeHistory =
  histchange = true

proc read*(editor: LineEditor): string =
  # starts at the top, full render moves it into the right y
  editor.fullRender()

  # TODO: must remove event at end
  # otherwise there'll be more instances of the same
  editor.events.add(jeHistoryChange, changeHistory)

  while not editor.finished:

    # refresh current line every time
    editor.render()
    setCursorXPos(editor.content.X + editor.prompt.len())
    # get key (with escapes)
    let key = getKey()
    # record y pos
    let preY = editor.content.Y
    # call the events
    editor.lastKeystroke = key
    editor.keystrokes.call(key)
    editor.events.call(jeKeypress)
    # redraw everything if y changed
    if histchange or preY != editor.content.Y:
      # move to the top
      if preY > 0:
        cursorUp(preY)
      # move to the right y
      editor.fullRender()
      if histchange:
        histchange = false

  # move cursor to end
  editor.moveCursorToEnd()
  editor.reset()
  
  return editor.content.getContent()
