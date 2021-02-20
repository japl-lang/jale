# Just Another Line Editor

or jale.nim

# Note

This is a new (and very immature) alternative to other
line editors such as linenoise (see rdstdin in the nim
standard library) or nimline (https://github.com/h3rald/nimline). Currently you probably want to use either of
those because this is a wip.

# Installation

```
git clone https://github.com/japl-lang/jale
cd jale
nimble install
```

# Checking the examples out

Building the examples

```
nimble examples
```

Checking the sample editor out. Quit with ctrl+c, save with ctrl+s. 

```
examples/editor <filename>
# or windows:
.\examples\editor.exe <filename>
```

Checking the interactive prompt out. Move between lines using ctrl+up/down. Create new lines with ctrl+down on the last line. ctrl+page up/down also works.

```
examples/interactive_history
# or windows:
.\examples\interactive_history.exe
```

# Features

- multiline support
- easily add new keybindings (using templates)
- very customizable (even inserting characters is a keybinding that's optional)
- plugin system based
- history
- horizontal scrolling

# Missing features

Note: they won't be missing forever hopefully.

- No utf-8
- No tab autocompletion support
- No syntax highlighting support
- Windows output still really unstable/untested in depth

