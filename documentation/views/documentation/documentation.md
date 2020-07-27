## Rorigami Documentation

This document describes in further details how Rorigami works and how it should be used. Rorigami 
is aiming to be simple, easy to use, batteries-included static website. Knowing the most basic of
HTML and Markdown is all that is required. It is still flexible enough to let you tweak the end
result to a considerable degree.

### HTML and Markdown

Knowing the most basic of HTML should be sufficient to work with Rorigami. In addition some CSS,
though not required would be useful if you want to further tweak it.

### Quickstart

All you need to do is download and extract the official package from [here](https://github.com/rorigami/rorigami).
The extracted package will contain a barebones version of the site you see here with the following structure:

```
.
├── application.yml
├── index.html
├── main.dart.js
├── static
│   ├── favicon.ico
│   ├── images
│   │   └── rorigami.png
│   ├── styles
│   │   ├── bulma.min.css
│   │   ├── fa.min.css
│   │   └── styles.css
│   └── webfonts
│       └── fa-brands-400.woff2
└── views
    ├── index
    │   └── index.html
    └── layout
        ├── contents.html
        ├── footer.html
        └── header.html
```

Start any static server from that directory, such as the standard python http server (available in all *nix based
operating systems) from the root directory and open up a browser:
 
* `$ python3 -m http.server` 
* Open [http://127.0.0.1:8000/](http://127.0.0.1:8000/) to see the end result.

### Configuration

All the configuration you care about is inside `application.yml` in the root directory. The basic configuration looks
as follows:

```
title: "Hello Rorigami!"           # Goes inside the <title> tag.
views: "views"                     # The directory where all the contents are located.
header: "layout/header.html"       # The header of the page, by default the navbar.
contents: "layout/contents.html"   # The wrapper around the contents of each page.
footer: "layout/footer.html"       # The footer of the page.
icon: "static/favicon.ico"         # The site favicon,
navbarId: "#_navbar"               # The id attribute of the navbar.
contentsId: "#_contents"           # The id attribute of the contents.
footerId: "#_footer"               # The id attribute of the footer.
logLevel: "ALL"                    # Loggin output to the developer console, available options are "ALL", "INFO", "WARNING", "SEVERE", "OFF"
initialPage: "index/index"         # The location of index.html inside the "views" directory
styles:                            # List of css stylesheets to load.
  - "static/styles/bulma.min.css"
  - "static/styles/fa.min.css"
  - "static/styles/styles.css"
```

In most cases you won't need to touch this file at all. In reality, the only thing you really need to change is
the title and possibly the `logLevel`. You may choose to add new stylesheets or modify the existing ones if you
need something more specific.

### Adding content

Adding content is as simple as adding a new file. You may opt in for using either Markdown or HTML. In the case of
the documentation that you are looking at, it's Markdown.

**To add an HTML page:**

1. Create a directory inside the `views` directory with a name of your choice. Say 'new_content'.
2. Inside 'new_content' add an html file. For example 'my_new_content.html' and put `<h1>This is my new Content</h1>`.
3. Save and while head on over to `http://127.0.0.1:8000/#new_content/my_new_content`.

That's it.

**To add a new Markdown page:**

1. Create a directory inside the `views` directory with a name of your choice. Say 'new_md_content'.
2. Inside 'new_content' add an html file. For example 'my_new_md_content.md' and put `# Markdown content`.
3. Save and while head on over to `http://127.0.0.1:8000/#new_md_content/my_new_content.md`.

Note that here we actually put the `.md` file extension. Internally Rorigami uses this to figure out if the content
should be parsed as markdown and translated to HTML for the browser. If there is no `.md` extension Rorigami will
load attempt to load the link by appending `.html` so you don't have to add it.

### Adding links.

1. HTML

* HTML links work just like anywhere else on the web. To put a link to an external site, say Github, all y
ou need to add in your html is `<a href="https://github.com/">Go to Github</a>` and that is it.
* To link within your static pages you need to use Rorigami's router.In this case the link should begin 
with a hash (`#`), followed by a path to the target html or markdown page, i.e.
`<a href="#new_content/my_new_content">Go to my new content</a>`.
* For a markdown document, the process is the sam, except you need to add the `.md` extension.

2. Markdown

Same rules apply as the html:

* External looks like `[this](http://github.com)`.
* Within the static site it looks like `[this](#new_content/my_new_content)` or `[this](#new_md_content/my_new_content.md)`
respectively.

That's all there is to it. Enjoy :)

## Wanna get involved?

Sure, check some further details [here](#documentation/development.md).
