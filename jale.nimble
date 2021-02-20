# Package

version       = "0.1.0"
author        = "Productive2"
description   = "Just Another Line Editor"
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 1.0.0"

import os
task examples, "Builds examples":
  for kind, path in walkDir("examples/"):
    if path.splitFile().ext == ".nim":
      let (oup, exitcode) = gorgeEx "nim c " & path
      if exitcode != 0:
        echo "Failed building example " & path
        echo oup
      else:
        echo "Successfully built example " & path
