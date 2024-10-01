# blog_example

An example blog site boilerplate and the beginnings of a minimal static site generator built with Gleam, Wisp, and Lustre.

## Motivation

I wanted to do some long-form writing about my current programming interests. I looked at sites like Medium and dev.to as well as static site
generators like Hugo and Jekyll, but decided to just try my hand at writing my own blog site that I could self-host on Fly.io.

## How does it work?

Blog posts can be generated with the following command.

```gleam
gleam run -m blog_example/generate new <slug>
```

Blog posts are composed of `post.djot` (for your actual blog post content) and `metadata.toml` (for additional information such as
the author, title, description, etc.) files. These files are generated using the post slug in a timestamped directory within
`src/blog_example/content/posts`. The metadata file needs to be completely filled out (i.e. no field removed or left as an empty string)
in order to be rendered by the web server.

Once that's done, run the following command to generate the manifest file that the web server will read to serve blog post requests.

```gleam
gleam run -m blog_example/generate
```

Note: This command will need to be run every time that a metadata file is changed.

Once you're ready to fire up your web server, simply run the following command.

```gleam
gleam run
```

Your blog posts will be listed on `http://localhost:8000/writing` and a specific blog post can be read on `http://localhost:8000/writing/<slug>`.

## Goals

I didn't set out to create a professional static site generator at the level of Hugo, Jekyll, and others. This started mainly to satisfy my own
curiosity about Gleam and its web libraries Wisp and Lustre.

That said, there are some features I'd like to add:

- Convert to a library that can be plugged into an existing Wisp application.
- Add support for markdown or improve support for syntax highlighting in code blocks.
- Add caching so that the djot files aren't read on every request.
- Add pagination in case of very active blogging.
- Add SQLite to enable features like "last edited on" and "search posts by tag".
- (Maybe) use the generator and metadata approach to generate other parts of a page.
