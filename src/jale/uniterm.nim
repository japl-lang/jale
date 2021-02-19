## Universal (cross platform) terminal abstractions

# source: https://github.com/h3rald/nimline/blob/master/nimline.nim
# lines 42-56 (modified)

import strutils
import terminal

when defined(windows):
  proc putchr(c: cint): cint {.discardable, header: "<conio.h>", importc: "_putch".}
  proc getchr(): cint {.header: "<conio.h>", importc: "_getch".}

  proc uniPutChr*(c: char) =
    ## Prints an ASCII character to stdout.
    putchr(c.cint)
  proc uniGetChr*: int =
    ## Retrieves an ASCII character from stdin.
    getchr().int

else:
  proc uniPutChr*(c: char) =
    ## Prints an ASCII character to stdout.
    stdout.write(c)

  proc uniGetChr*: int =
    ## Retrieves an ASCII character from stdin.
    return getch().int

type TermWriter* = distinct string

proc `&=`*(wr: var TermWriter, str: string) =
  wr = TermWriter(string(wr) & str)

proc lf*(wr: var TermWriter) =
  wr &= "\n"

proc cr*(wr: var TermWriter) =
  when defined(windows):
    wr &= ($27.char & "[0G")
  else:
    wr &= "\r"

proc up*(wr: var TermWriter, count: int) =
  if count == 0:
    return
  wr &= ($27.char & "[" & $count & "A")

proc down*(wr: var TermWriter, count: int) =
  if count == 0:
    return
  wr &= ($27.char & "[" & $count & "B")

proc clearLine*(wr: var TermWriter) =
  when defined(windows):
    wr &= ($27.char & "[1M" & $27.char & "[1L")
  else:
    wr &= ($27.char & "[2K")

proc setCursorX*(wr: var TermWriter, x: int) =
  when defined(windows):
    wr &= ($27.char & "[" & $x & "G")
  else:
    if x == 0:
      wr &= "\r"
    else:
      wr &= ("\r" & $27.char & "[" & $x & "C")

proc terminalWidth*(wr: var TermWriter): int =
  terminalWidth()

proc flush*(wr: var TermWriter) =
  stdout.write(cast[string](wr))
  wr = cast[TermWriter]("")

