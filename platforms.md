
# Platforms

Reading vt100 docs/relying on nim's terminal is not enough, it's best to
test everything out there. Different terminal emulators, a few different OS'es
or distros and also windows specific emulators.

Unless otherwise specified, everything falls back to Artix linux (basically the same versions of software as arch), x86_64, nim 1.4.2.

| Terminal              | Last tested and worked                        |
| :--------             | :------------                                 |
| xfce terminal         | passed on 26.2.2021                           |
| konsole               | passed on 26.2.2021                           |
| alacritty             | passed on 26.2.2021                           |
| xterm                 | passed on 26.2.2021                           |
| termite               | passed on 26.2.2021                           |
| urxvt                 | passed on 26.2.2021                           |
| win 10 + cmd.exe      | 26.2.2021: see notes                          |
| win 10 + powershell   | 26.2.2021: see notes                          |
| xfce terminal + ssh   | passed on 26.2.2021                           |
| xfce terminal + tmux  | 26.2.2021: see notes                          |
| tty                   | 26.2.2021: see notes                          |
| freebsd xterm         | passed on 19.2.2021                           |
| freebsd xfce term     | passed on 19.2.2021                           |
| debian xterm          | passed on 19.2.2021                           |
| debian qterminal      | passed on 19.2.2021                           |
| debian kitty          | passed on 19.2.2021                           |
| nim 1.0.0             | passed on 26.2.2021                           |

Info about testing dates:

| Testing date | commit                                   |
| :----------- | :--------                                |
| 19.2.2021    | 12c7c28714508e7a1c16bcd7b3fa1372c4a19ae2 |
| 26.2.2021    | d4d2f52ec13a3c5cfea2cdce2d09777317de3545 |

## Notes on 26.2.2021

### Found issues

- (minor, doesn't affect repls) examples/editor does not scroll to the
end right after opening when opening a file too large to fit in the screen.

- (minor) examples/interactive_history when a history element is taller than the screen,
it can cause issues with the rendering of the next history element when scrolling
through history

### tmux notes

- ctrl+pageup and ctrl+page down do not create any input (not even for getch)
- otherwise pass

### tty notes

- ctrl+(arrow keys) does not create a distinct key

### powershell notes

- editor issues:
- on horizontal scroll conditions the line can overflow causing rendering bugs
- on vertical scroll + page up the first line could disappear (maybe only when first line is a horizontal scroll candidate)
- very slow experience, a lot of cursor jumping

### cmd.exe notes

- same issues as powershell

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
- [ ] horizontal scroll
- [ ] vertical scroll

