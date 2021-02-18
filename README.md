# Just Another Line Editor

or jale.nim

# Note

This is a new (and very immature) alternative to other
line editors such as linenoise (see rdstdin in the nim
standard library) or nimline (https://github.com/h3rald/nimline). Currently you probably want to use either of
those because this is a wip.

# Building

Have nim (tested on 1.4.2, x86_64 gnu/linux) installed.

```
git clone https://github.com/japl-lang/jale
cd jale
nim c main
./main
```

You should enter a temporary testing prompt, which you
can quit with ctrl+c.
Pressing enter when the last line is empty submits
the output.

# Features

- multiline support
- easily add new keybindings (using templates)
- very customizable (even inserting characters is a keybinding that's optional)
- plugin system based
- history

# Example usage

```nim
# for now, from the same directory where it's cloned
# import the line editor
import editor
# import the default keybindings for basic stuff
# like arrow key movement or inserting characters
import plugin/defaults
# import helper templates for adding custom key or
# event bindings
import templates

# create the line editor
let e = newLineEditor()
# set its prompt to something
e.prompt = "> "
# add the default keybindings
e.populateDefaults()

var printOutput = true

# very weird use case, but if ctrl+b is pressed during reading, don't
# print the output
e.bindKey("ctrl+b"):
	printOutput = false

let input = e.read()
if printOutput:
	echo "output:"
	echo input
```

Also see examples folder if the above example does not suffice,
and look at defaults.nim for many binding examples.
Look at multiline.nim's procs and editor.nim's 
LineEditor type for an "API". It's wip, docs will 
improve if it ever gets more stable.

# Missing features

Note: they won't be missing forever hopefully.

- No utf-8
- No tab autocompletion support
- No syntax highlighting support
- Windows keybindings not finished, windows was not tested yet

