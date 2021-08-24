import karax/[karaxdsl, vdom]

proc sharedNav*(): VNode =
  let vNode = buildHtml(header):
    nav(class = "navbar", id = "navbar"):
      a(class = "navbar-link", href = "/blog"): text "Blog"
      a(class = "navbar-link", href = "/series"): text "Series"

  return vNode
