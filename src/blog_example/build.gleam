import blog_example/posts
import blog_example/web/pages/home
import blog_example/web/pages/post
import blog_example/web/pages/writing
import gleam/dict
import gleam/io
import gleam/list
import lustre/ssg

pub fn main() {
  let posts = case posts.fetch() {
    Error(_) -> []
    Ok(posts) -> posts
  }

  let recent_posts = posts |> list.take(3)

  let posts_dict =
    posts
    |> list.fold(dict.new(), fn(d, p) { d |> dict.insert(p.slug, p) })

  let build =
    ssg.new("./priv/static")
    |> ssg.add_static_route("/", home.page(recent_posts))
    |> ssg.add_static_route("/writing", writing.page(posts))
    |> ssg.add_dynamic_route("/writing", posts_dict, post.page)
    |> ssg.build

  case build {
    Ok(_) -> io.println("Build succeeded!")
    Error(e) -> {
      io.debug(e)
      io.println("Build failed!")
    }
  }
}
