import blog_example/content.{type Post}
import blog_example/web/layouts/base
import lustre/attribute.{href}
import lustre/element.{text}
import lustre/element/html.{a, h1, hgroup, html, p, section}
import lustre/ssg/djot

pub fn page(post: Post) {
  html([], [
    hgroup([], [
      h1([], [a([href("/")], [text("Lorem Ipsum")])]),
      p([], [text("Lorem ipsum odor amet")]),
    ]),
    section([], post.content |> djot.render(djot.default_renderer())),
  ])
  |> base.layout
}
