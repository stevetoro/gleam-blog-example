import argv
import birl
import gleam/int
import gleam/io
import gleam/string
import simplifile

const posts_dir = "src/blog_example/posts/"

pub fn main() {
  case argv.load().arguments {
    ["slug", slug] -> {
      let new_post = create_post(slug)
      io.println("created " <> new_post)
    }
    _ -> io.println("Usage: new slug <slug>")
  }
}

fn create_post(slug: String) {
  let now = birl.utc_now()

  let new_post =
    posts_dir <> now |> birl.to_unix |> int.to_string <> "_" <> slug <> ".djot"

  let assert Ok(_) = simplifile.create_file(new_post)

  let assert Ok(_) =
    simplifile.write(new_post, template(slug, now |> birl.to_iso8601))

  new_post
}

fn template(slug: String, date: String) {
  let frontmatter = fn() {
    "---\n"
    <> "slug = \"$slug\"\n"
    <> "title = \"\"\n"
    <> "description = \"\"\n"
    <> "author = \"\"\n"
    <> "date = \"$date\"\n"
    <> "---\n\n"
    <> "# New Post"
  }

  frontmatter()
  |> string.replace("$slug", slug)
  |> string.replace("$date", date)
}
