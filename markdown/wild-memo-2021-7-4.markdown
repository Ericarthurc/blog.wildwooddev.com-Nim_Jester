---
title: How blog.wildwooddev works
date: July 4, 2021
tags: wildwood, wildwooddev, markdown, html, parser
---

# How blog.wildwooddev works

<style>
  .mvc {
    width: 300px;
  }

  @media screen and (min-width: 1000px) {
    .mvc {
      width: 450px;
    }
  }

  .mvc img {
    width: 100%;
  }

  .fire-text {
    background: -webkit-linear-gradient(315deg, #ff4e00 0%, #ec9f05 74%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    -webkit-mask-image: linear-gradient(
      -75deg,
      rgba(255, 255, 255, 0.6) 30%,
      rgb(255, 255, 255) 50%,
      rgba(255, 255, 255, 0.6) 70%
    );
    -webkit-mask-size: 200%;
    animation: shine 1.7s linear infinite;
    font-weight: bold;
  }

  @keyframes shine {
  from {
    -webkit-mask-position: 150%;
  }
  to {
    -webkit-mask-position: -50%;
  }
}

  
</style>

I wanted to do a little technical preview post on how I designed aspects of the parser for this site. And touch a little on how the backend works as well.

## Technologies Used

This site is designed using a couple different technologies.

- <a href="https://nodejs.org/en/" target="_blank" rel="noreferrer">Nodejs</a> | Javascript runtime engine
- <a href="https://koajs.com/" target="_blank" rel="noreferrer">Koa</a> | Nodejs web server framework
- <a href="https://ejs.co/" target="_blank" rel="noreferrer">EJS</a> | HTML templating engine
- <a href="https://www.markdownguide.org/" target="_blank" rel="noreferrer">Markdown</a> | Markdown text syntax
- <a href="https://marked.js.org/" target="_blank" rel="noreferrer">MarkdownJS</a> | Markdown parser
- <a href="https://www.nginx.com/" target="_blank" rel="noreferrer">Nginx</a> | Reverse proxy

## Backend Layout

The backend layout I choose for this project is based around a common design pattern called <a href="https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller" target="_blank" rel="noreferrer">MVC</a>.

- M: Model
- V: View
- C: Controller

<div class="mvc">

![Backend Layout](/images/mvclayout.png)

</div>

This is a picture of some of the actual code layout for this site. You can see there is a folder called 'views', that comes straight from that 'MVC' design pattern. You may also notice there isn't a 'Model' or 'Controller' folder within this structure. This is due to the need of the site itself.

- 'Models' are computer code representations of a database model
- 'Views' take care of html templating, or what you see on the site
- 'Controllers' are actions that are run when a web route is matched like "/blog"

In the name of keeping this site very simple, no database is used for this site; all files are locally parsed through for data, instead of being placed in a database. And this site is so simple it only uses two controller style functions, so I didn't feel a need to dedicate the file space for them (subject to change as the need grows).

## How Markdown is Parsed

This sites main and only goal is to allow the user to read blog style posts. This is pretty simple in design but actually requires some design work and different choices were made for simplicity sake. When you load up a website there are main different files that are loaded so you can view the site. One of the major files is the .html file, this file contains all the text that is displayed to the users browser. HTML stands for 'hyper-text markup language'; so is this the same as 'Markdown'? Well they are both markup languages but very different in application and syntax. This website takes Markdown and turns it into HTML, and I will show you why and how.

### Why Markdown is Converted to HTML

Lets look at some code examples of HTML verses Markdown

#### HTML:

```html
<h1>Hello World!</h1>
```

#### Markdown:

```Markdown
# Hello World!
```

So that is a super simple example, but both of those lines translate to the same thing; a string of characters that say 'Hello World!'

Now lets look at an example using a code block it self, this time lets put the markdown first.\
Side note: If you are on mobile you will probably have to scroll the code blocks to the sides to see everything.

#### Markdown:

````Markdown
```ts
import { serve } from "https://deno.land/std/http/server.ts";
const s = serve({ port: 8000 });
console.log("http://localhost:8000/");
for await (const req of s) {
  req.respond({ body: "Hello World\n" });
}
```
````

#### HTML:

```html
<code class="language-ts hljs language-typescript"
  ><span class="hljs-keyword">import</span> { serve }
  <span class="hljs-keyword">from</span>
  <span class="hljs-string">"https://deno.land/std/http/server.ts"</span>;
  <span class="hljs-keyword">const</span> s =
  <span class="hljs-title function_">serve</span>({
  <span class="hljs-attr">port</span>: <span class="hljs-number">8000</span> });
  <span class="hljs-variable language_">console</span>.<span
    class="hljs-title function_"
    >log</span
  >(<span class="hljs-string">"http://localhost:8000/"</span>);
  <span class="hljs-keyword">for</span>
  <span class="hljs-keyword">await</span> (<span class="hljs-keyword"
    >const</span
  >
  req <span class="hljs-keyword">of</span> s) { req.<span
    class="hljs-title function_"
    >respond</span
  >({ <span class="hljs-attr">body</span>:
  <span class="hljs-string">"Hello World\n"</span> }); }
</code>
```

Ummmm what...that is a huge difference, the HTML is very difficult to read and understand, while the Markdown from someone who understands the coding language TypeScript (ts) is very human readable.

But we have a problem... the web browser can only read HTML, not Markdown.

So this is where parsing comes in! Parsing is the process of converting one thing into another! Markdown is human writeable and readable but needs to be parsed to HTML so the web browser can display it correctly!

### How Markdown is Converted to HTML

Well let me show you! Here are the two main parser functions this website uses to convert Markdown into HTML. This is a coding language called TypeScript, and its the main server language of this website.

```ts
export const getBlogIndexArray = async () => {
  interface IBlog {
    fileName: string;
    blogTitle: string;
    blogDate: any;
  }
  const blogsArray = [];
  const data = await fs.readdir("./blog/");
  for (const file of data) {
    const blog = <IBlog>{};
    blog.fileName = <string>file.substr(0, file.indexOf(".markdown"));
    const fileData = await fs.readFile(`./blog/${file}`);

    const meParsed = fileData
      .toString()
      .substr(0, fileData.toString().indexOf("#"))
      .replace(/---|  - |\r/g, "")
      .split("\n")
      .filter((x: any) => x != "")
      .filter((x: any) => x != "tags:")
      .map((x: any) => x.split(":").pop()?.trim());
    blog.blogTitle = <string>meParsed[0];
    blog.blogDate = new Date(<string>meParsed[1]);
    blogsArray.push(blog);
  }
  return blogsArray.sort((a, b) => b.blogDate - a.blogDate);
};
```

```ts
export const parseMarkdown = async (fileName: string) => {
  const data = await fs.readFile(`./blog/${fileName}.markdown`);
  const parsed = marked(data.toString());
  const body = parsed.substr(parsed.indexOf("<h1"));

  const headers = parsed
    .substr(0, parsed.indexOf("<h1"))
    .replace(/(<([^>]+)>)/gi, "")
    .split("\n")
    .filter((x) => x != "")
    .filter((x) => x != "tags:")
    .map((x) => x.split(": ").pop());

  const head = headers.slice(0, 2);
  const tags = headers.slice(2);

  return { body, header: { title: head[0], date: head[1], tags } };
};
```

Pretty crazy huh?! These two functions are how this website is possible. Using a combination of string regex manipulation, functional programming and advanced parsing I am able to convert Markdown files into HTML so you can enjoy these posts. I know this isn't very explanatory, but it's very complex and would take too long to layout. You can imagine it like this in simple terms; the parser loads a file that has `# Hello!` markdown in it. When the parser sees a '#' it converts it to a `<h1>` then places the text after and adds a `</h1>` at the end for `<h1>Hello</h1>`. And the parser goes through every single line and knows how to translate the Markdown language to the HTML language. And this process is very fast! Here is a benchmark of the parser with a single markdown file from this site.

```ps
PS C:\Users\*\Desktop\parser> ts-node .\main.ts
Start parsing wild-memo-2021-7-5.markdown!
Parsed in 5.984899997711182 milliseconds!
```

5.9 milliseconds per file! WoW! <span class="fire-text">Super fast!</span> 🚀

## The Frontend

And then lastly all this information is served to the user via an http server called Koa. This is an exchange of information. When you click a link to a blog post, the server is sent a message from your computer asking for that specific blog. The server then searches for that blog, parses it to HTML and sends it to your browser for viewing!

```ts
blogRouter.get("/:id", async (ctx: Context, next: Next) => {
  const blogId = ctx.params.id;

  try {
    const parsedObj = await parseMarkdown(blogId);
    await ctx.render("blogpost", {
      body: parsedObj.body,
      title: parsedObj.header.title,
      date: parsedObj.header.date,
      tags: parsedObj.header.tags,
    });
  } catch (error) {
    await next();
  }
});
```

If you look at this function, the "/:id" part is how the server knows what blog post you want to view. This blog post has an id of `/wild-memo-2021-7-4`. That is passed to the server which allows it to find this post file for parsing.

## Source Files

I want to end this blog post by showing you the complete source code for this page in both Markdown and HTML. These will be external links, due to how long they are; but try to imagine writing the HTML part by hand. It is doable but a lot of work. This blog post was hand written in Markdown and it takes just as long as writing a word doc file, pretty cool!

<a href="/source/html.text" target="_blank" rel="noreferrer">HTML Source</a>

<a href="/source/markdown.text" target="_blank" rel="noreferrer">Markdown Source</a>

## Conclusion

Thanks for reading!

### Eric Christensen
