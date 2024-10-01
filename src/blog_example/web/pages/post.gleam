import blog_example/web/layouts/base
import lustre/attribute.{href}
import lustre/element.{type Element, text}
import lustre/element/html.{a, h1, hgroup, html, p, section}

pub fn page(post: List(Element(t))) {
  html([], [
    hgroup([], [
      h1([], [a([href("/")], [text("Lorem Ipsum")])]),
      p([], [text("Lorem ipsum odor amet")]),
    ]),
    section([], post),
  ])
  |> base.layout
}
