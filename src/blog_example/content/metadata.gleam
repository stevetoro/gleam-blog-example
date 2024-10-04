import birl
import decode
import gleam/dict
import gleam/json
import gleam/list
import gleam/result
import simplifile
import tom

const posts_dir = "src/blog_example/content/posts/"

const metadata_json = "src/blog_example/content/metadata-generated.json"

pub type Metadata {
  Metadata(
    slug: String,
    title: String,
    description: String,
    author: String,
    location: String,
    date: String,
  )
}

pub type Error {
  ReadFileError
  DecodeError
  NotFound
  TomParseError
  TomGetError
}

pub fn get(slug: String) {
  use file <- result.try(
    simplifile.read(metadata_json)
    |> result.replace_error(ReadFileError),
  )
  use posts <- result.try(
    json.decode(file, decode.from(decode.dict(decode.string, metadata()), _))
    |> result.replace_error(DecodeError),
  )
  use post <- result.try(
    dict.get(posts, slug)
    |> result.replace_error(NotFound),
  )

  Ok(post)
}

pub fn get_valid_metadata() {
  use file <- result.try(
    simplifile.read(metadata_json)
    |> result.replace_error(ReadFileError),
  )
  use posts <- result.try(
    json.decode(file, decode.from(decode.dict(decode.string, metadata()), _))
    |> result.replace_error(DecodeError),
  )

  Ok(
    dict.keys(posts)
    |> list.map(fn(key) {
      let assert Ok(metadata) = dict.get(posts, key)
      metadata
    })
    |> list.filter(fn(metadata) { metadata |> validate })
    |> list.sort(fn(m1, m2) {
      let assert Ok(d1) = m1.date |> birl.parse()
      let assert Ok(d2) = m2.date |> birl.parse()
      birl.compare(d2, d1)
    }),
  )
}

pub fn read_metadata_files() {
  use dirs <- result.try(
    simplifile.read_directory(posts_dir)
    |> result.replace_error(ReadFileError),
  )

  dirs
  |> list.map(fn(dir) { read_metadata_file(in: posts_dir <> dir) })
  |> result.all()
}

fn read_metadata_file(in dir: String) {
  use toml <- result.try(
    simplifile.read(dir <> "/metadata.toml")
    |> result.replace_error(ReadFileError),
  )
  use doc <- result.try(
    tom.parse(toml)
    |> result.replace_error(TomParseError),
  )
  use slug <- result.try(
    tom.get_string(doc, ["slug"])
    |> result.replace_error(TomGetError),
  )
  use title <- result.try(
    tom.get_string(doc, ["title"])
    |> result.replace_error(TomGetError),
  )
  use description <- result.try(
    tom.get_string(doc, ["description"])
    |> result.replace_error(TomGetError),
  )
  use author <- result.try(
    tom.get_string(doc, ["author"])
    |> result.replace_error(TomGetError),
  )
  use location <- result.try(
    tom.get_string(doc, ["location"])
    |> result.replace_error(TomGetError),
  )
  use date <- result.try(
    tom.get_string(doc, ["date"])
    |> result.replace_error(TomGetError),
  )

  Ok(Metadata(slug, title, description, author, location, date))
}

fn metadata() {
  decode.into({
    use slug <- decode.parameter
    use title <- decode.parameter
    use description <- decode.parameter
    use author <- decode.parameter
    use location <- decode.parameter
    use date <- decode.parameter
    Metadata(slug, title, description, author, location, date)
  })
  |> decode.field("slug", decode.string)
  |> decode.field("title", decode.string)
  |> decode.field("description", decode.string)
  |> decode.field("author", decode.string)
  |> decode.field("location", decode.string)
  |> decode.field("date", decode.string)
}

fn validate(metadata: Metadata) {
  metadata.slug != ""
  && metadata.title != ""
  && metadata.description != ""
  && metadata.author != ""
  && metadata.date != ""
  && metadata.location != ""
}
