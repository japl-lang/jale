# only works on posix (through handling SIGWINCH signals)

import ../editor
import ../event

when defined(posix):
  import posix

var editors: seq[LineEditor]

proc bindResize*(ed: LineEditor) =
  editors.add(ed)

when defined(posix):
  onSignal(28):
    for ed in editors:
      ed.events.call(jeResize)
