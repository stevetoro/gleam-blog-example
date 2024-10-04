import birl
import blog_example/content.{type Post}
import blog_example/web/layouts/base
import gleam/list
import lustre/attribute.{href}
import lustre/element.{text}
import lustre/element/html.{a, h1, h2, hgroup, html, li, p, section, ul}

pub fn page(posts: List(Post)) {
  html([], [
    hgroup([], [
      h1([], [a([href("/")], [text("Writing page")])]),
      p([], [text("This page will contain a list of all of your blog posts.")]),
    ]),
    writings_section(posts),
  ])
  |> base.layout
}

fn writings_section(posts: List(Post)) {
  case posts |> list.is_empty {
    True -> element.none()
    False ->
      section([], [ul([], posts |> list.map(fn(post) { post_element(post) }))])
  }
}

fn post_element(post: Post) {
  let formatted_date = case birl.parse(post.date) {
    Error(_) -> post.date
    Ok(parsed) -> birl.to_naive_date_string(parsed)
  }

  li([], [
    h2([], [a([href("/writing/" <> post.id)], [text(post.title)])]),
    p([], [text(post.description)]),
    p([], [text("Written by " <> post.author <> " on " <> formatted_date)]),
  ])
}
