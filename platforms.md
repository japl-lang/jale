This short document describes the testing strategy and status for jale.
Jale should be tested on different active versions of different
terminal emulators. Also on different OSes. This document describes which
platforms are being/planned on being tested and a testing procedure.

Note: this is a wip document, await updates once the bug hunt starts

# Platforms

Unless otherwise specified, everything falls back to Arch linux, x86_64, nim 1.4.2.


| Terminal              | Last tested and worked |
| :--------             | :------------          |
| gnome terminal        | never                  |
| xfce terminal         | passed on 16.2.2021    |
| lxterminal            | never                  |
| konsole               | never                  |
| alacritty             | never                  |
| xterm                 | never                  |
| urxvt                 | never                  |
| cmd.exe               | never                  |
| powershell            | never                  |
| windows terminal      | never                  |
| gnome terminal + ssh  | never                  |
| gnome terminal + tmux | never                  |

# Testing procedure

examples/interactive_basic
- [ ] Jale compiles?
- [ ] Entering single line input, backspace, delete
- [ ] entering new lines, deleting lines with backspace
- [ ] home/end/page up/page down
- [ ] Submitting output
examples/interactive_history
- [ ] Multiple multiline history events
examples/editor
- [ ] Clears the screen well
- [ ] Writing small files
- [ ] Reading small files

