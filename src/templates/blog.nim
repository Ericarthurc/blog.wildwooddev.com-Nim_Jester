import strtabs, strformat, tables
import karax/[karaxdsl, vdom]

import ../utils/parsers
import share/head
import share/navbar
import share/footer

proc blogIndexSection(parsedMetaSeq: seq[Table[string, string]]): VNode =
  result = buildHtml(main(class = "content")):
    tdiv(class = "main-container"):
      h2(class = "main-header"): text "Wildwood Tech Posts"
      ul(class = "index-list"):
        for meta in parsedMetaSeq:
          li:
            a(class = "list-anchor", href = fmt"""/blog/{meta["fileName"]}"""):
              tdiv(class = "list-anchor__info"):
                span(class = "info-title"): text meta["title"]
                span(class = "info-date"): text meta["date"]

proc blogIndex*(parsedMetaSeq: seq[Table[string, string]]): string =
  let head = sharedHead("Blog")
  let navbar = sharedNav()
  let body = blogIndexSection(parsedMetaSeq)
  let scripts = sharedFooter()
  let vNode = buildHtml(html(lang = "en")):
    head
    navbar
    body
    scripts

  result = "<!DOCTYPE html>\n" & $vNode



proc blogSection(parsedMarkdown: string,
    parsedMeta: Meta): VNode =
  result = buildHtml(main(class = "content")):
    tdiv(class = "blog-container"): verbatim parsedMarkdown
    p(class = "tags"):
      text "Tags "
      for tag in parsedMeta.tags:
        verbatim fmt("`{tag}` ")

proc blogPage*(title: string, parsedMarkdown: string,
    parsedMeta: Meta): string =
  let head = sharedHead(parsedMeta.title)
  let navbar = sharedNav()
  let body = blogSection(parsedMarkdown, parsedMeta)
  let scripts = sharedFooter()
  let vNode = buildHtml(html(lang = "en")):
    head
    navbar
    body
    scripts

  result = "<!DOCTYPE html>\n" & $vNode
