import gleam/list
import lustre/attribute.{href}
import lustre/element.{type Element}
import lustre/element/html.{
  a, body, footer, head, header, html, li, main, p, text, title, ul,
}

pub fn layout(content: Element(t)) {
  html([], [
    head([], [title([], "Lorem Ipsum")]),
    body([], [
      header([], []),
      main([], [content]),
      footer([], [
        p([], [
          text("A footer with social media links and copyright statement."),
        ]),
        footer_links(),
        copyright(),
      ]),
    ]),
  ])
  |> element.to_string_builder
}

fn footer_links() {
  let socials =
    [
      #("X", "https://x.com/"),
      #("GitHub", "https://github.com/"),
      #("LinkedIn", "https://linkedin.com/"),
    ]
    |> list.map(fn(social) { li([], [a([href(social.1)], [text(social.0)])]) })

  html([], [ul([], socials)])
}

fn copyright() {
  html([], [
    p([], [text("Copyright © 2024, Lorem Ipsum. All rights reserved.")]),
  ])
}
