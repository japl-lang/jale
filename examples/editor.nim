import ../plugin/defaults
import ../editor
import ../strutils
import ../templates

import terminal

let e = newLineEditor()
e.prompt = ""
e.populateDefaults(enterSubmits = false)
let input = e.read()

