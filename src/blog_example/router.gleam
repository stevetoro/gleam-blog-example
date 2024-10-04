import blog_example/content
import blog_example/context.{type Context}
import gleam/http.{Get}
import gleam/list
import wisp.{type Request, type Response}

pub fn handle(ctx: Context, req: Request) -> Response {
  use req <- middleware(ctx, req)
  case wisp.path_segments(req) {
    [] -> home(ctx, req)
    ["writing"] -> writing(ctx, req)
    ["writing", slug] -> post(ctx, req, slug)
    _ -> wisp.redirect("/")
  }
}

fn middleware(
  ctx: Context,
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)
  use <- wisp.serve_static(req, under: "/", from: ctx.static_directory)
  handle_request(req)
}

fn home(ctx: Context, req: Request) {
  use <- wisp.require_method(req, Get)

  wisp.response(200)
  |> wisp.set_body(wisp.File(ctx.static_directory <> "/index.html"))
}

fn writing(ctx: Context, req: Request) {
  use <- wisp.require_method(req, Get)

  wisp.response(200)
  |> wisp.set_body(wisp.File(ctx.static_directory <> "/writing.html"))
}

fn post(ctx: Context, req: Request, slug: String) {
  use <- wisp.require_method(req, Get)

  let content = case content.fetch_all() {
    Error(_) -> []
    Ok(posts) -> posts
  }

  let found = content |> list.any(fn(post) { post.id == slug })

  case found {
    // TODO: Add 404 page.
    False -> wisp.redirect("/")
    True ->
      wisp.response(200)
      |> wisp.set_body(wisp.File(
        ctx.static_directory <> "/writing/" <> slug <> ".html",
      ))
  }
}
