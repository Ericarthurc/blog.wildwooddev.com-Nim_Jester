import strtabs, strformat
import karax/[karaxdsl, vdom]

import share/head
import share/navbar
import share/footer

proc errorPage*(): string =
  let head = sharedHead("Series", true)
  let navbar = sharedNav()

  let body = buildHtml(tdiv(class = "error-container")):
    pre:
      code(class = "language-powershell hljs"):
        span(class = "hljs-built_in"): text "Failed to connect to port"

  let scripts = sharedFooter(true)
  let vNode = buildHtml(html(lang = "en")):
    head
    navbar
    body
    scripts

  result = "<!DOCTYPE html>\n" & $vNode
