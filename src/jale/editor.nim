import strformat
import strutils
import tables

import line
import multiline
import keycodes
import event
import renderer
import terminal

type 
  JaleEvent* = enum
    jeKeypress, jeQuit, jeFinish, jePreRead, jePostRead

  EditorState = enum
    esOutside, esTyping, esFinishing, esQuitting

  LineEditor* = ref object
    # permanents
    keystrokes*: Event[int]
    events*: Event[JaleEvent]
    prompt*: string

    # permanent internals: none
    
    # per-read contents
    content*: Multiline
    lastKeystroke*: int
    # per-read internals
    state: EditorState
    rendered: int # how many lines were printed last full refresh
    forceRedraw: bool

# getter/setter sorts

proc unfinish*(le: LineEditor) =
  le.state = esTyping

proc finish*(le: LineEditor) =
  le.state = esFinishing
  # can be overwritten to false, inside the event
  le.events.call(jeFinish)

proc quit*(le: LineEditor) =
  le.state = esQuitting
  le.events.call(jeQuit)

proc redraw*(le: LineEditor) =
  le.forceRedraw = true

# constructor

proc newLineEditor*: LineEditor =
  new(result)
  result.content = newMultiline()
  result.keystrokes.new()
  result.events.new()
  result.prompt = ""
  result.rendered = 0
  result.lastKeystroke = -1
  result.forceRedraw = false
  result.state = esOutside
  
# priv/pub methods

proc reset(editor: LineEditor) =
  ## Resets state to outside, resets internal rendering details
  ## resets last keystroke, creates new contents
  editor.state = esOutside
  editor.rendered = 0
  editor.content = newMultiline()
  editor.lastKeystroke = -1
  editor.forceRedraw = false

proc render(editor: LineEditor, line: int = -1, hscroll: bool = true) =
  var y = line
  if y == -1:
    y = editor.content.Y

  let prompt = if y == 0: editor.prompt else: " ".repeat(editor.prompt.len())
  renderLine(prompt, editor.content.getLine(y), 0)

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
    eraseLine()
    cursorDown(1)
    dec editor.rendered
    inc extraup

  cursorUp(editor.content.len() - editor.content.Y + extraup)

proc moveCursorToEnd(editor: LineEditor) =
  # only called when read finished
  if editor.content.high() > editor.content.Y:
    cursorDown(editor.content.high() - editor.content.Y)
  write stdout, "\n"

proc read*(editor: LineEditor): string =

  editor.state = esTyping
  editor.events.call(jePreRead)

  # starts at the top, full render moves it into the right y
  editor.fullRender()

  while editor.state == esTyping:

    # refresh current line every time
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
    if editor.forceRedraw or preY != editor.content.Y:
      # move to the top
      if preY > 0:
        cursorUp(preY)
      # move to the right y
      editor.fullRender()
      if editor.forceRedraw:
        editor.forceRedraw = false
    else:
      editor.render()

  editor.events.call(jePostRead)

  # move cursor to end
  editor.moveCursorToEnd()
  if editor.state == esFinishing:
    result = editor.content.getContent()
  editor.reset()
