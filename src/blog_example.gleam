import blog_example/context.{Context}
import blog_example/posts
import blog_example/router
import gleam/erlang/process
import gleam/list
import mist
import wisp
import wisp/wisp_mist

pub fn main() {
  wisp.configure_logger()

  let secret_key_base = wisp.random_string(64)

  let handler = router.handle(context(), _)

  let assert Ok(_) =
    wisp_mist.handler(handler, secret_key_base)
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  process.sleep_forever()
}

fn context() {
  let assert Ok(posts) = posts.fetch()
  let available_slugs = posts |> list.map(fn(post) { post.slug })
  Context(static_directory(), available_slugs)
}

fn static_directory() {
  let assert Ok(priv_directory) = wisp.priv_directory("blog_example")
  priv_directory <> "/static"
}
