# keycodes.nim

import tables
import strutils
import terminal

type
  JaleKeycode* = enum
    jkStart = 255 # jale keycodes exported start one above jkStart
    jkLeft = 256, jkRight, jkUp, jkDown, jkHome, jkEnd, jkDelete, jkBackspace,
    jkInsert, jkEnter

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
  escapeSeqs[result] = id

block:
  when defined(windows):
    defEscSeq(@[224], jkContinue)
    defEscSeq(@[224, 72], jkUp)
    defEscSeq(@[224, 80], jkDown)
    defEscSeq(@[224, 77], jkRight)
    defEscSeq(@[224, 75], jkLeft)
    defEscSeq(@[224, 71], jkHome)
    defEscSeq(@[224, 79], jkEnd)
    defEscSeq(@[224, 82], jkInsert)
    defEscSeq(@[224, 83], jkDelete)
    # TODO: finish defining escape sequences
  else:
    defEscSeq(@[27], jkContinue)
    defEscSeq(@[27, 91], jkContinue)
    defEscSeq(@[27, 91, 65], jkUp)
    defEscSeq(@[27, 91, 66], jkDown)
    defEscSeq(@[27, 91, 67], jkRight)
    defEscSeq(@[27, 91, 68], jkLeft)
    defEscSeq(@[27, 91, 72], jkHome)
    defEscSeq(@[27, 91, 70], jkEnd)
    defEscSeq(@[27, 91, 51], jkContinue)
    defEscSeq(@[27, 91, 50], jkContinue)
    defEscSeq(@[27, 91, 51, 126], jkDelete)
    defEscSeq(@[27, 91, 50, 126], jkInsert)
    defEscSeq(@[13], jkEnter)
    defEscSeq(@[127], jkBackspace)

proc getKey*: int =
  var key: int = 0
  while true:
    key *= 256
    key += int(getch())
    if escapeSeqs.hasKey(key):
      if escapeSeqs[key] != jkContinue:
        key = int(escapeSeqs[key])
        break
    else:
      break
  return key
