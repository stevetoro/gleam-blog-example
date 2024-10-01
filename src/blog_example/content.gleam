import blog_example/content/metadata
import gleam/result
import jot
import jot_to_lustre
import simplifile

pub type Error {
  GetMetadataError
  ReadFileError
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
    |> jot.parse
    |> jot_to_lustre.document_to_lustre,
  )
}
