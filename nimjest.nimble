# Package

version       = "0.9.4"
author        = "Ericarthurc"
description   = "Nim backend tests"
license       = "MIT"
srcDir        = "src"
bin           = @["server"]


# Dependencies

requires "nim >= 1.4.8"
requires "jester >= 0.5.0"
requires "karax >= 1.2.1"
requires "nmark >= 0.1.10"

task prodbuild, "Build for production":
    exec "nimble build -d:release --threads:on"

task extension, "Install all extensions":
  exec "nimble install jester@#head"
  exec "nimble install karax"
  exec "nimble install nmark"