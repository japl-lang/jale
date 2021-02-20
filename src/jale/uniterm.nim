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
