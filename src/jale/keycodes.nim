# keycodes.nim

import tables
import strutils
import uniterm

type
  JaleKeycode* = enum
    jkStart = 255 # jale keycodes exported start one above jkStart
    # arrow keys
    jkLeft = 256, jkRight, jkUp, jkDown, 
    jkCtrlLeft, jkCtrlRight, jkCtrlUp, jkCtrlDown,
    # other 4 move keys
    jkHome, jkEnd, jkPageUp, jkPageDown,
    jkCtrlHome, jkCtrlEnd, jkCtrlPageUp, jkCtrlPageDown,
    # special keys
    jkDelete, jkBackspace, jkInsert, jkEnter,

    jkFinish, # jale keycodes exported end one below jkFinish
    # non-exported jale keycodes come here:
    jkContinue # represents an unfinished escape sequence

var keysById*: Table[int, string]
var keysByName*: Table[string, int]

block:
  # 1 - 26
  for i in countup(1, 26): # iterate through lowercase letters
    keysById[i] = "ctrl+" & $char(i + 96)

  keysById[9] = "tab"
  # keysById[8] will never get triggered because it's an escape seq

  keysById[28] = r"ctrl+\"
  keysById[29] = "ctrl+]"
  keysByName[r"ctrl+\"] = 28
  keysByName["ctrl+]"] = 29

  for i in countup(1, 26):
    keysByName[keysById[i]] = i

  # jale keycodes:
  for i in countup(int(jkStart) + 1, int(jkFinish) - 1):
    var name: string = ($JaleKeycode(i))
    name = name[2..name.high()].toLower()
    keysByName[name] = i
    keysById[i] = name

var escapeSeqs*: Table[int, JaleKeycode]

proc defEscSeq(keys: seq[int], id: JaleKeycode) =
  var result = 0
  for key in keys:
    result *= 256
    result += key
  if escapeSeqs.hasKey(result):
    raise newException(Defect, "Duplicate escape sequence definition")
  escapeSeqs[result] = id

block:
  when defined(windows):
    defEscSeq(@[224], jkContinue)
    
    # arrow keys
    defEscSeq(@[224, 72], jkUp)
    defEscSeq(@[224, 80], jkDown)
    defEscSeq(@[224, 77], jkRight)
    defEscSeq(@[224, 75], jkLeft)
    # ctrl+arrow keys
    defEscSeq(@[224, 141], jkCtrlUp)
    defEscSeq(@[224, 145], jkCtrlDown)
    defEscSeq(@[224, 116], jkCtrlRight)
    defEscSeq(@[224, 115], jkCtrlLeft)
    # moves
    defEscSeq(@[224, 71], jkHome)
    defEscSeq(@[224, 79], jkEnd)
    defEscSeq(@[224, 73], jkPageUp)
    defEscSeq(@[224, 81], jkPageDown)
    # ctrl+moves
    defEscSeq(@[224, 134], jkCtrlPageUp)
    defEscSeq(@[224, 118], jkCtrlPageDown)
    defEscSeq(@[224, 119], jkCtrlHome)
    defEscSeq(@[224, 117], jkCtrlEnd)
    
    # special keys
    defEscSeq(@[8], jkBackspace)
    defEscSeq(@[13], jkEnter)
    defEscSeq(@[224, 82], jkInsert)
    defEscSeq(@[224, 83], jkDelete)
  else:
    # arrow keys
    defEscSeq(@[27], jkContinue)
    defEscSeq(@[27, 91], jkContinue)
    defEscSeq(@[27, 91, 65], jkUp)
    defEscSeq(@[27, 91, 66], jkDown)
    defEscSeq(@[27, 91, 67], jkRight)
    defEscSeq(@[27, 91, 68], jkLeft)

    # ctrl+arrow keys
    defEscSeq(@[27, 91, 49], jkContinue)
    defEscSeq(@[27, 91, 49, 59], jkContinue)
    defEscSeq(@[27, 91, 49, 59, 53], jkContinue) # ctrl

    defEscSeq(@[27, 91, 49, 59, 50], jkContinue) # shift

    defEscSeq(@[27, 91, 49, 59, 53, 65], jkCtrlUp) # ctrl
    defEscSeq(@[27, 91, 49, 59, 53, 66], jkCtrlDown) # ctrl
    defEscSeq(@[27, 91, 49, 59, 53, 67], jkCtrlRight) # ctrl
    defEscSeq(@[27, 91, 49, 59, 53, 68], jkCtrlLeft) # ctrl

    # urxvt
    defEscSeq(@[27, 79], jkContinue)
    defEscSeq(@[27, 79, 97], jkCtrlUp)
    defEscSeq(@[27, 79, 98], jkCtrlDown)
    defEscSeq(@[27, 79, 99], jkCtrlRight)
    defEscSeq(@[27, 79, 100], jkCtrlLeft)

    # other 4 move keys
    defEscSeq(@[27, 91, 72], jkHome)
    defEscSeq(@[27, 91, 70], jkEnd)
    defEscSeq(@[27, 91, 54], jkContinue)
    defEscSeq(@[27, 91, 53], jkContinue)
    defEscSeq(@[27, 91, 53, 126], jkPageUp)
    defEscSeq(@[27, 91, 54, 126], jkPageDown)
    # alternative home/end for tty
    defEscSeq(@[27, 91, 49, 126], jkHome)
    defEscSeq(@[27, 91, 52], jkContinue)
    defEscSeq(@[27, 91, 52, 126], jkEnd)
    # urxvt
    defEscSeq(@[27, 91, 55], jkContinue)
    defEscSeq(@[27, 91, 56], jkContinue)
    defEscSeq(@[27, 91, 55, 126], jkHome)
    defEscSeq(@[27, 91, 56, 126], jkEnd)

    # ctrl + fancy keys like pgup, pgdown, home, end
    defEscSeq(@[27, 91, 53, 59], jkContinue)
    defEscSeq(@[27, 91, 53, 59, 53], jkContinue)
    defEscSeq(@[27, 91, 53, 59, 53, 126], jkCtrlPageUp)
    defEscSeq(@[27, 91, 54, 59], jkContinue)
    defEscSeq(@[27, 91, 54, 59, 53], jkContinue)
    defEscSeq(@[27, 91, 54, 59, 53, 126], jkCtrlPageDown)

    defEscSeq(@[27, 91, 49, 59, 53, 72], jkCtrlHome)
    defEscSeq(@[27, 91, 49, 59, 53, 70], jkCtrlEnd)

    # urxvt
    defEscSeq(@[27, 91, 53, 94], jkCtrlPageUp)
    defEscSeq(@[27, 91, 54, 94], jkCtrlPageDown)
    defEscSeq(@[27, 91, 55, 94], jkCtrlHome)
    defEscSeq(@[27, 91, 56, 94], jkCtrlEnd)

    # other keys
    defEscSeq(@[27, 91, 51], jkContinue)
    defEscSeq(@[27, 91, 50], jkContinue)
    defEscSeq(@[27, 91, 51, 126], jkDelete)
    defEscSeq(@[27, 91, 50, 126], jkInsert)
    defEscSeq(@[13], jkEnter)
    defEscSeq(@[127], jkBackspace)
    defEscSeq(@[8], jkBackspace) 

proc getKey*: int =
  var key: int = 0
  while true:
    key *= 256
    key += int(uniGetChr())
    if escapeSeqs.hasKey(key):
      if escapeSeqs[key] != jkContinue:
        key = int(escapeSeqs[key])
        break
    else:
      break
  return key
