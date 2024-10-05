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
  use <- wisp.require_method(req, Get)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use <- wisp.serve_static(req, under: "/", from: ctx.static_directory)
  handle_request(req)
}

fn home(ctx: Context, _req: Request) {
  wisp.response(200)
  |> wisp.set_body(wisp.File(ctx.static_directory <> "/index.html"))
}

fn writing(ctx: Context, _req: Request) {
  wisp.response(200)
  |> wisp.set_body(wisp.File(ctx.static_directory <> "/writing.html"))
}

fn post(ctx: Context, _req: Request, slug: String) {
  let valid_slug = ctx.available_slugs |> list.contains(slug)

  case valid_slug {
    False -> wisp.redirect("/writing")
    True ->
      wisp.response(200)
      |> wisp.set_body(wisp.File(
        ctx.static_directory <> "/writing/" <> slug <> ".html",
      ))
  }
}
