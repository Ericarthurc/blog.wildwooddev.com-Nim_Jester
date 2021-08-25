import asyncdispatch, jester

import /utils/parsers
import /templates/blog
import /templates/series

settings:
  port = Port(4003)

routes:
  get "/":
    redirect "/blog"

  get "/blog":
    let parsedMetaSeq = await getMetaSeqTwo()
    resp blogIndex(parsedMetaSeq)

  get "/blog/@blog":
    try:
      let (parsedMarkdown, parsedMeta) = await getMarkdownAndMeta(@"blog")
      resp blogPage(@"blog", parsedMarkdown, parsedMeta)
    except:
      resp Http404

  get "/series":
    let seriesSeq = await getSeriesSeq()
    resp seriesIndex(seriesSeq)

  get "/series/@series":
    try:
      let parsedMetaSeq = await getMetaBySeries(@"series")
      resp seriesPage(parsedMetaSeq)
    except:
      resp Http404
