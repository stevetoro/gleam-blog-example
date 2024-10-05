# blog_example

A statically generated blog site, built with Gleam, Wisp, and Lustre.

## Motivation

I wanted to do some long-form writing about my current programming interests. I looked at sites like Medium and dev.to as well as static site
generators like Hugo and Jekyll, but instead decided to try my hand at writing my own statically generated blog site with Gleam and Lustre
as a learning exercise.

## How does it work?

Blog posts can be generated with the following command.

```bash
gleam run -m blog_example/new slug <slug>
```

This will generate a timestamped `.djot` file under `src/blog_example/posts` with some default metadata and other metadata that needs to be
filled out in order for the static site generator to build your site.

Once the metadata's been filled out, run the static site generator with the following command.

```bash
gleam run -m blog_example/build
```

Once you're ready to fire up your web server, simply run the following command.

```bash
gleam run
```

Your blog posts will be listed on `http://localhost:8000/writing` and a specific blog post can be read on `http://localhost:8000/writing/<slug>`.
