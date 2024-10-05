import birl
import gleam/list
import gleam/result
import gleam/string
import lustre/ssg/djot
import simplifile
import tom

const posts_dir = "src/blog_example/posts/"

pub type Post {
  Post(
    slug: String,
    title: String,
    description: String,
    author: String,
    date: String,
    content: String,
  )
}

pub fn fetch() {
  use post_files <- result.try(
    simplifile.read_directory(posts_dir)
    |> result.replace_error(ReadFileError),
  )

  use posts <- result.try(
    post_files
    |> list.map(extract_post)
    |> result.all(),
  )

  Ok(
    posts
    |> list.filter(validate)
    |> list.sort(most_recent),
  )
}

fn extract_post(file: String) {
  use file <- result.try(
    simplifile.read(posts_dir <> file)
    |> result.replace_error(ReadFileError),
  )
  use toml <- result.try(
    djot.metadata(file) |> result.replace_error(ReadFileError),
  )
  use slug <- result.try(
    tom.get_string(toml, ["slug"])
    |> result.replace_error(TomGetError),
  )
  use title <- result.try(
    tom.get_string(toml, ["title"])
    |> result.replace_error(TomGetError),
  )
  use description <- result.try(
    tom.get_string(toml, ["description"])
    |> result.replace_error(TomGetError),
  )
  use author <- result.try(
    tom.get_string(toml, ["author"])
    |> result.replace_error(TomGetError),
  )
  use date <- result.try(
    tom.get_string(toml, ["date"])
    |> result.replace_error(TomGetError),
  )

  let content =
    djot.content(file)
    |> string.crop("---")
    |> string.crop("---")
    |> string.replace("---", "")

  Ok(Post(slug, title, description, author, date, content))
}

fn validate(post: Post) {
  post.slug != ""
  && post.title != ""
  && post.description != ""
  && post.author != ""
  && post.date != ""
  && post.content != ""
}

fn most_recent(p1: Post, p2: Post) {
  let assert Ok(d1) = p1.date |> birl.parse()
  let assert Ok(d2) = p2.date |> birl.parse()
  birl.compare(d2, d1)
}

pub type Error {
  GetMetadataError
  ReadFileError
  TomGetError
}
