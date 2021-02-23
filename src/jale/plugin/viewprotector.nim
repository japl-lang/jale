import ../editor
import ../templates

import terminal

type ViewBehavior* = enum
  vbLines, vbLinesLimited, vbFullscreen

proc setViewBehavior*(ed: LineEditor, behavior: ViewBehavior) =
  case behavior:
    of vbLines:
      ed.bindEvent(jeResize):
        ed.vmax = terminalHeight() - 1
    of vbLinesLimited:
      discard
    of vbFullscreen:
      var resized = false
      ed.bindEvent(jeResize):
        ed.vmax = terminalHeight() - 1
        ed.redraw()
        resized = true
      ed.bindEvent(jePreFullRender):
        if resized:
          eraseScreen()
          setCursorPos(0,0)
          resized = false

