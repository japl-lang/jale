import history
import ../editor
import ../multiline
import ../templates

import options

proc plugHistory*(ed: LineEditor): History =
  # adds hooks to events
  # after reading finished, it adds to history
  # before reading, it adds the temporary input to the history
  let hist = newHistory()
  
  ed.bindEvent(jeFinish):
    hist.clean()
    hist.newEntry(ed.content)
    
  ed.bindEvent(jePreRead):
    hist.newEntry(ed.content, temp = true)
    discard hist.toEnd()

  return hist


proc bindHistory*(ed: LineEditor, h: History, useShift: bool = false) =
  ## Adds history keybindings to editor (up, down, pg up/down)
  ## Works with the history provided
  ## if useShift is true, then the up/down keys and page up/down
  ## will remain free, and shift+up/down and ctrl+pg up/down
  ## will be used
  
  let upkey = if useShift: "shiftup" else: "up"
  let downkey = if useShift: "shiftdown" else: "down"
  let homekey = if useShift: "ctrlpageup" else: "pageup"
  let endkey = if useShift: "ctrlpagedown" else: "pagedown"

  ed.bindKey(upkey):
    let res = h.delta(-1)
    if res.isSome():
      ed.content = res.get()
      ed.redraw()

  ed.bindKey(downkey):
    let res = h.delta(1)
    if res.isSome():
      ed.content = res.get()
      ed.redraw()

  ed.bindKey(homekey):
    let res = h.toStart()
    if res.isSome():
      ed.content = res.get()
      ed.redraw()

  ed.bindKey(endKey):
    let res = h.toStart()
    if res.isSome():
      ed.content = res.get()
      ed.redraw()

