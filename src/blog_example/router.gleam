import blog_example/content
import blog_example/content/metadata
import blog_example/web/pages/home
import blog_example/web/pages/post
import blog_example/web/pages/writing
import gleam/http.{Get}
import wisp.{type Request, type Response}

pub fn handle(req: Request) -> Response {
  use req <- middleware(req)
  case wisp.path_segments(req) {
    [] -> home(req)
    ["writing"] -> writing(req)
    ["writing", slug] -> post(req, slug)
    _ -> wisp.redirect("/")
  }
}

fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)
  handle_request(req)
}

fn home(req: Request) {
  use <- wisp.require_method(req, Get)

  let metadata = case metadata.get_valid_metadata() {
    Error(_) -> []
    Ok(metadata) -> metadata
  }

  home.page(metadata)
  |> wisp.html_response(200)
}

fn writing(req: Request) {
  use <- wisp.require_method(req, Get)

  let metadata = case metadata.get_valid_metadata() {
    Error(_) -> []
    Ok(metadata) -> metadata
  }

  writing.page(metadata)
  |> wisp.html_response(200)
}

fn post(req: Request, slug: String) {
  use <- wisp.require_method(req, Get)

  case content.fetch(for: slug) {
    Error(_) -> wisp.redirect("/")
    Ok(post) ->
      post.page(post)
      |> wisp.html_response(200)
  }
}
