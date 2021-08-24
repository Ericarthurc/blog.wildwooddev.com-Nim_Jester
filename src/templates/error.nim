import strtabs, strformat
import karax/[karaxdsl, vdom]
import prologue

import share/head
import share/navbar
import share/footer

proc errorPage*(ctx: Context): string =
  let head = sharedHead(ctx, "Series")
  let navbar = sharedNav(ctx)

  let body = buildHtml(tdiv(class = "error-container")):
    pre:
      code(class = "language-powershell hljs"):
        span(class = "hljs-built_in"): text "Failed to connect to port"

  let scripts = sharedFooter(ctx)
  let vNode = buildHtml(html(lang = "en")):
    head
    navbar
    body
    scripts

  result = "<!DOCTYPE html>\n" & $vNode
