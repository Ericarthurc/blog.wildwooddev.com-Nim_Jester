import karax/[karaxdsl, vdom]

proc sharedFooter*(highlightEnabler: bool): VNode =
  let vNode = buildHtml(tdiv):
    if highlightEnabler:
      script(): verbatim "hljs.highlightAll();"
    script(): verbatim r"""if (!navigator.serviceWorker.controller) {
        navigator.serviceWorker.register("/sw.js").then(function(reg) {
        console.log("Service worker registered for scope: " + reg.scope);
        });
        }"""
    script(): verbatim r"""console.log(`%cPowered by Nim {v0.9.3}!`, "color: #FFE220");"""

  return vNode
