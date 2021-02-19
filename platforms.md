
# Platforms

Reading vt100 docs/relying on nim's terminal is not enough, it's best to
test everything out there. Different terminal emulators, a few different OS'es
or distros and also windows specific emulators.

Unless otherwise specified, everything falls back to Artix linux (basically the same versions of software as arch), x86_64, nim 1.4.2.

| Terminal              | Last tested and worked                        |
| :--------             | :------------                                 |
| xfce terminal         | passed on 19.2.2021                           |
| konsole               | passed on 19.2.2021                           |
| alacritty             | passed on 19.2.2021                           |
| xterm                 | passed on 19.2.2021                           |
| urxvt                 | failed on 19.2.2021 (probably not vt100 comp) |
| cmd.exe               | never                                         |
| powershell            | never                                         |
| windows terminal      | never                                         |
| cygwin                | never                                         |
| termux/android        | never                                         |
| xfce terminal + ssh   | passed on 19.2.2021                           |
| xfce terminal + tmux  | failed on 19.2.2021                           |
| tty                   | ? on 19.2.2021 (see notes)                    |
| freebsd tty           | ? on 19.2.2021 (see notes)                    |
| freebsd xterm         | passed on 19.2.2021                           |
| freebsd xfce term     | passed on 19.2.2021                           |
| debian xterm          | passed on 19.2.2021                           |
| debian qterminal      | passed on 19.2.2021                           |
| debian kitty          | passed on 19.2.2021                           |
| nim 1.0.0             | failed to compile on 19.2.2021                |

Info about testing dates:

| Testing date | commit                                   |
| :----------- | :--------                                |
| 19.2.2021    | 12c7c28714508e7a1c16bcd7b3fa1372c4a19ae2 |

## Notes (open in a text editor to see this section well)

urxvt: Ctrl+down outputted a "b", so most likely different escape sequence (not the usual vt100).
The following sequences are in out of the box urxvt:
ctrl up: 27, 79, 97
ctrl down: 27, 79, 98
ctrl left: 27, 79, 100
ctrl right: 27, 79, 99
ctrl pgup: 27, 91, 53, 94
ctrl pgdn: 27, 91, 54, 94
ctrl home: 27, 91, 55, 94
ctrl end: 27, 91, 56, 94
home: 27, 91, 55, 126
end: 27, 91, 56, 126
already should be fixed, will update at next testing date

tmux, the following input differs:
end: 27, 91, 52, 126
home: 27, 91, 49, 126
(ctrl versions fine)

tty:
ctrl makes no difference on arrow keys
home: 27, 91, 49, 126
end: 27, 91, 52, 126
home/end already should be fixed, will update at next testing date

freebsd tty:
ctrl makes no difference on arrow keys

nim 1.0.0:
already should be fixed, will update at next testing date

# Testing procedure

Platform
- [ ] Jale compiles?
examples/interactive_basic
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

