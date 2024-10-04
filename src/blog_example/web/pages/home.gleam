import birl
import blog_example/content.{type Post}
import blog_example/web/layouts/base
import gleam/list
import lustre/attribute.{href}
import lustre/element.{text}
import lustre/element/html.{a, h1, h2, h3, hgroup, html, li, p, section, ul}

pub fn page(recent_posts: List(Post)) {
  html([], [
    hgroup([], [
      h1([], [text("Home page")]),
      p([], [
        text(
          "Maybe a short description of yourself or the content on the site.",
        ),
      ]),
    ]),
    section([], [
      h2([], [text("Section")]),
      p([], [text("A section with whatever static content you want.")]),
    ]),
    writing_section(recent_posts),
  ])
  |> base.layout
}

fn writing_section(posts: List(Post)) {
  case posts |> list.is_empty {
    True -> element.none()
    False ->
      section([], [
        h2([], [a([href("/writing")], [text("Recent")])]),
        p([], [text("A list of your most recent blog posts.")]),
        ul([], posts |> list.map(fn(post) { post_element(post) })),
      ])
  }
}

fn post_element(post: Post) {
  let formatted_date = case birl.parse(post.date) {
    Error(_) -> post.date
    Ok(parsed) -> birl.to_naive_date_string(parsed)
  }

  li([], [
    h3([], [a([href("/writing/" <> post.id)], [text(post.title)])]),
    p([], [text("written on " <> formatted_date)]),
  ])
}
