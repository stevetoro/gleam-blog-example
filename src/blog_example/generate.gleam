import argv
import birl
import blog_example/content/metadata
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/string
import simplifile

const posts_dir = "src/blog_example/content/posts/"

const generated_file = "src/blog_example/content/metadata-generated.json"

pub fn main() {
  case argv.load().arguments {
    [] -> {
      let assert Ok(_) = generate_metadata()
      io.println("rewrote " <> generated_file)
    }
    ["new", slug] -> {
      let #(new_post, new_metadata) = create_post(slug)
      io.println("created " <> new_post)
      io.println("created " <> new_metadata)
      let assert Ok(_) = generate_metadata()
      io.println("rewrote " <> generated_file)
    }
    _ -> io.println("Usage: new <slug>")
  }
}

fn create_post(slug: String) {
  let now = birl.utc_now()

  let new_dir = posts_dir <> now |> birl.to_unix |> int.to_string <> "_" <> slug
  let new_post = new_dir <> "/post.djot"
  let new_metadata = new_dir <> "/metadata.toml"

  let assert Ok(_) = simplifile.create_directory(new_dir)
  let assert Ok(_) = simplifile.create_file(new_post)
  let assert Ok(_) = simplifile.create_file(new_metadata)

  let assert Ok(_) =
    simplifile.write(
      new_metadata,
      metadata(slug, new_post, now |> birl.to_iso8601),
    )

  #(new_post, new_metadata)
}

fn metadata(slug: String, location: String, date: String) {
  let template = fn() {
    "slug = \"$slug\"\n"
    <> "title = \"\"\n"
    <> "description = \"\"\n"
    <> "author = \"\"\n"
    <> "date = \"$date\"\n"
    <> "location = \"$location\"\n"
  }

  template()
  |> string.replace("$slug", slug)
  |> string.replace("$date", date)
  |> string.replace("$location", location)
}

fn generate_metadata() {
  let assert Ok(metadata) = metadata.read_metadata_files()

  metadata
  |> list.map(fn(metadata) {
    #(
      metadata.slug,
      json.object([
        #("slug", json.string(metadata.slug)),
        #("title", json.string(metadata.title)),
        #("description", json.string(metadata.description)),
        #("author", json.string(metadata.author)),
        #("date", json.string(metadata.date)),
        #("location", json.string(metadata.location)),
      ]),
    )
  })
  |> json.object
  |> json.to_string
  |> fn(generated) { simplifile.write(generated_file, generated) }
}
