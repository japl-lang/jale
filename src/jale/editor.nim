import strformat
import strutils
import tables

import line
import multiline
import keycodes
import event
import renderer
import terminal
import os

type 
  JaleEvent* = enum
    jeKeypress, jeQuit, jeFinish, jePreRead, jePostRead

  EditorState = enum
    esOutside, esTyping, esFinishing, esQuitting

  ScrollBehavior* = enum
    sbSingleScroll, sbAllScroll, sbWrap

  LineEditor* = ref object
    # permanents
    keystrokes*: Event[int]
    events*: Event[JaleEvent]
    prompt*: string
    scrollMode*: ScrollBehavior

    # permanent internals: none
    
    # per-read contents
    content*: Multiline
    lastKeystroke*: int
    # per-read internals
    state: EditorState
    rendered: int # how many lines were printed last full refresh
    forceRedraw: bool
    hscroll: int
    vmax: int
    vscroll: int

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
  result.scrollMode = sbSingleScroll
  result.hscroll = 0
  result.vscroll = 0
  result.vmax = terminalHeight() - 1
  
# priv/pub methods

proc reset(editor: LineEditor) =
  ## Resets state to outside, resets internal rendering details
  ## resets last keystroke, creates new contents
  editor.state = esOutside
  editor.rendered = 0
  editor.content = newMultiline()
  editor.lastKeystroke = -1
  editor.forceRedraw = false
  editor.hscroll = 0

proc render(editor: LineEditor, line: int = -1) =
  ## Assumes that the cursor is already on the right line then
  ## proceeds to render the line-th line of the editor (if -1, will check
  ## the y).
  var y = line
  if y == -1:
    y = editor.content.Y
 
  # the prompt's length is assumed to be always padded
  let prompt = if y == 0: editor.prompt else: " ".repeat(editor.prompt.len())
  let content = editor.content.getLine(y)

  if editor.scrollMode == sbAllScroll or 
    (editor.scrollMode == sbSingleScroll and y == editor.content.Y):
    renderLine(prompt, content, editor.hscroll)
  else:
    renderLine(prompt, content, 0)

proc fullRender(editor: LineEditor) =
  # from the top cursor pos, it draws the entire multiline prompt, then
  # moves cursor to current y

  let lastY = min(editor.content.high(), editor.vscroll + editor.vmax - 1)
  for i in countup(editor.vscroll, lastY):
    editor.render(i)
    if i - editor.vscroll < editor.rendered:
      cursorDown(1)
    else:
      write stdout, "\n"
      inc editor.rendered

  let rendered = lastY - editor.vscroll + 1
  var extraup = 0
  while rendered < editor.rendered:
    eraseLine()
    cursorDown(1)
    dec editor.rendered
    inc extraup

  # return to the selected y pos
  cursorUp(lastY + 1 - editor.content.Y + extraup)

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
    setCursorXPos(editor.content.X - editor.hscroll + editor.prompt.len())
    # get key (with escapes)

    let key = getKey()
    # record y pos
    let preY = editor.content.Y
    let preVScroll = editor.vscroll

    # call the events
    editor.lastKeystroke = key
    editor.keystrokes.call(key)
    editor.events.call(jeKeypress)
    # autoscroll horizontally based on current scroll and x pos
    
    # last x rendered
    let lastX = terminalWidth() - editor.prompt.len() + editor.hscroll - 1
    # first x rendered
    let firstX = editor.hscroll

    # x squished into boundaries
    let boundX = min(max(firstX, editor.content.X), lastX)
    if editor.content.X != boundX:
      editor.hscroll += editor.content.X - boundX
      if editor.scrollMode == sbAllScroll:
        editor.forceRedraw = true

    # first y possibly rendered
    let firstY = editor.vscroll
    let lastY = editor.vscroll + editor.vmax - 1

    # y squished into boundaries
    let boundY = min(max(firstY, editor.content.Y), lastY)
    if editor.content.Y != boundY:
      editor.vscroll += editor.content.Y - boundY
      
      editor.forceRedraw = true

    # redraw everything if y changed
    if editor.forceRedraw or preY != editor.content.Y or preVScroll != editor.vscroll:
      # move to the top
      if preY - preVScroll > 0:
        cursorUp(preY - preVScroll)
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
