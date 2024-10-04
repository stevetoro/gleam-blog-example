import blog_example/content/metadata
import gleam/list
import gleam/result
import lustre/ssg/djot
import simplifile

pub type Post {
  Post(
    id: String,
    title: String,
    description: String,
    author: String,
    date: String,
    content: String,
  )
}

pub fn fetch(for slug: String) {
  use metadata <- result.try(
    metadata.get(slug)
    |> result.replace_error(GetMetadataError),
  )
  use post <- result.try(
    simplifile.read(metadata.location)
    |> result.replace_error(ReadFileError),
  )

  Ok(
    post
    |> djot.render(djot.default_renderer()),
  )
}

pub fn fetch_all() {
  use metadata <- result.try(
    metadata.get_valid_metadata()
    |> result.replace_error(GetMetadataError),
  )

  metadata
  |> list.map(fn(metadata) {
    use post <- result.try(
      simplifile.read(metadata.location) |> result.replace_error(ReadFileError),
    )
    Ok(Post(
      id: metadata.slug,
      title: metadata.title,
      description: metadata.description,
      author: metadata.author,
      date: metadata.date,
      content: post,
    ))
  })
  |> result.all
}

pub type Error {
  GetMetadataError
  ReadFileError
}
