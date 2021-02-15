Soon:

Horizontal scrolling for the current line in render
Add new keycodes (enter, ctrl+h, ctrl+j?)
Add a way to hook for the quit event (ctrl+c or ctrl+d auto triggers in default)
Move arrow keys to per-key events/create template that hooks by name
create template that hooks any key

Multiline editing:

- when moving up/down render should re-render the line to reset horizontal scrolling

Other stuff:

- move codebase into multiple modules to ensure modularity (move away defaults and anything that can be submodules (keycodes) e.g.)
- tab completion into the defaults
- new events such as pre-terminate, pre-return, pre-render (filter)


Done:
