import strutils, strformat, sequtils, sugar, os, asyncfile,
        asyncdispatch, std/algorithm, times
import nmark

type Meta* = object
    fileName*: string
    title*: string
    date*: string
    tags*: seq[string]
    series*: string

proc metaParser(rawData: string, fileName: string): Meta =
    ## splits file string and takes top header, then parses each line into the right Meta object field
    var t = Meta()

    var lined = rawData.split("---")[1].split("\n")
    lined = map(lined, (x) => replace(x, "\c", ""))
    for line in lined:
        if not(isEmptyOrWhitespace(line)):
            case line.split(":")[0]:
                of "title":
                    t.title = line.split(":")[1].strip()
                of "date":
                    t.date = line.split(":")[1].strip()
                of "tags":
                    t.tags = line.split(":")[1].strip().split(", ")
                of "series":
                    t.series = line.split(":")[1].strip()
        t.fileName = fileName
    return t

proc markdownParser(rawData: string): string =
    ## splits file string into three parts; maxsplit = 2 to avoid accidental splits after header
    var lined = rawData.split("---", maxsplit = 2)[2]
    return lined.markdown



proc getMarkdownAndMeta*(fileName: string): Future[(string, Meta)] {.async.} =
    ## Parse markdown to HTML and get Meta
    try:
        var file = openAsync(fmt"./markdown/{fileName}.markdown")
        let data = await file.readAll()
        file.close()
        return (markdownParser(data), metaParser(data, fileName))
    except:
        raise newException(ValueError, fmt"{fileName} can't be found!")

proc getMetaSeq*(): Future[seq[Meta]] {.async.} =
    ## Get sequence of blog meta (filename, date) [sorted by date]
    var filesMeta: seq[Meta] = @[]

    let filesInPath = toSeq(walkDir("./markdown", relative = true))
    for file in filesInPath:
        var fileData = openAsync(fmt"./markdown/{file.path}")
        let data = await fileData.readAll()
        filesMeta.add metaParser(data, file.path.split(".")[0])
        fileData.close()

    # sort seq[Meta] by date
    sort(filesMeta, (x, y) => parse(x.date, "MMMM d, yyyy") < parse(y.date,
            "MMMM d, yyyy"))

    return filesMeta

proc getSeriesSeq*(): Future[seq[string]] {.async.} =
    ## Get set of series [sorted alphabetically]
    var seriesSeq: seq[string] = @[]

    var metaSeq = await getMetaSeq()
    for meta in metaSeq:
        if meta.series != "":
            seriesSeq.add meta.series

    var uniqueSeries = deduplicate(seriesSeq)
    sort(uniqueSeries, (x, y) => x > y)

    return uniqueSeries

proc getMetaBySeries*(series: string): Future[seq[Meta]] {.async.} =
    ## Get sequence of blog meta by series (filename, date) [sorted by date]

    var metaSeq = await getMetaSeq()
    metaSeq = filter(metaSeq, proc(x: Meta): bool = x.series == series)

    let seriesSeq = await getSeriesSeq()
    if seriesSeq.count(series) == 0:
        raise newException(ValueError, fmt"{series} can't be found!")
    else:
        return metaSeq
