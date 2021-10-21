defmodule SvgBuilderTest do
  use ExUnit.Case
  doctest SvgBuilder

  use SvgBuilder
  use Tesla

  @moduletag :external

  plug(Tesla.Middleware.BaseUrl, "https://validator.w3.org/nu/")

  plug(Tesla.Middleware.Headers, [
    {"content-type", "image/svg+xml; charset=utf-8"},
    {"User-Agent", "SvgBuilder/1.0"}
  ])

  plug(Tesla.Middleware.JSON)

  test "creates valid SVG" do
    shapes =
      [
        Shape.rect(10, 10, 30, 20),
        Shape.rounded_rect(50, 10, 30, 20, 5, 5),
        Shape.circle(100, 20, 10),
        Shape.ellipse(130, 20, 15, 10),
        Shape.line(160, 30, 190, 10) |> Painting.stroke(:black),
        Shape.polyline([{200, 30}, {210, 10}, {230, 20}]) |> Painting.stroke(:green),
        Shape.polygon([{250, 30}, {250, 10}, {280, 10}]) |> Painting.stroke(:green)
      ]
      |> Element.group()
      |> Metadata.title("Shapes")

    paths =
      [
        Path.path()
        |> Path.move(10, 50)
        |> Path.line_to(40, 50)
        |> Path.line_to_rel(0, 20)
        |> Path.horizontal_rel(30)
        |> Path.vertical_rel(-20)
        |> Painting.fill(:none)
        |> Painting.stroke(:green),
        Path.path()
        |> Path.move(80, 50)
        |> Path.cubic([{80, 50}, {100, 40}, {100, 80}])
        |> Path.smooth_cubic([{200, 40}, {140, 40}])
        |> Path.quadratic([{140, 90}, {150, 40}, {200, 80}, {200, 40}])
        |> Painting.fill(:none)
        |> Painting.stroke(:red),
        Path.path()
        |> Path.move(200, 80)
        |> Path.arc(10, 10, 0, 1, 1, 250, 50)
        |> Painting.fill(:goldenrod)
        |> Painting.stroke(:black)
      ]
      |> Element.group()
      |> Metadata.title("Paths")

    paintings =
      [
        Shape.rect(10, 100, 20, 20)
        |> Painting.fill(:pink),
        Shape.rect(40, 100, 20, 20)
        |> Painting.fill({240, 30, 45}),
        Shape.rect(70, 100, 20, 20)
        |> Painting.fill(:none)
        |> Painting.stroke(:seagreen),
        Shape.rect(100, 100, 20, 20)
        |> Painting.fill(:none)
        |> Painting.stroke({100, 100, 0}),
        Shape.rect(130, 100, 20, 20)
        |> Painting.fill(:none)
        |> Painting.stroke(:black)
        |> Painting.stroke_width("5px"),
        Shape.rect(160, 100, 20, 20)
        |> Painting.fill(:none)
        |> Painting.stroke(:black)
        |> Painting.stroke_width("2px")
        |> Painting.stroke_dasharray([2, 2]),
        Shape.line(190, 120, 210, 100)
        |> Painting.stroke(:black)
        |> Painting.stroke_width("5px")
        |> Painting.stroke_linecap(:round),
        Shape.polyline([{220, 120}, {240, 100}, {260, 120}])
        |> Painting.stroke(:black)
        |> Painting.stroke_width("5px")
        |> Painting.stroke_linejoin(:round)
      ]
      |> Element.group()
      |> Metadata.title("Painting")

    transforms =
      [
        Shape.rect(0, 0, 20, 20)
        |> Painting.fill(:lightgrey),
        Shape.rect(0, 0, 20, 20)
        |> Transform.translate(10, 10),
        Shape.rect(30, 0, 20, 20)
        |> Painting.fill(:lightgrey),
        Shape.rect(30, 0, 20, 20)
        |> Transform.rotate(45, 40, 10),
        Shape.rect(60, 0, 20, 20)
        |> Painting.fill(:lightgrey),
        Shape.rect(60, 0, 20, 20)
        |> Transform.scale(0.8, 2.0),
        Shape.rect(90, 0, 20, 20)
        |> Painting.fill(:lightgrey),
        Shape.rect(90, 0, 20, 20)
        |> Transform.skew_x(30),
        Shape.rect(120, 0, 20, 20)
        |> Painting.fill(:lightgrey),
        Shape.rect(120, 0, 20, 20)
        |> Transform.skew_y(30),
        Shape.rect(150, 0, 20, 20)
        |> Painting.fill(:lightgrey),
        Shape.rect(150, 0, 20, 20)
        |> Transform.matrix({1.0, 0.0, 0.2, 1.0, 2.0, 5.0})
      ]
      |> Element.group()
      |> Element.add_attribute(:opacity, 0.75)
      |> Transform.translate(10, 140)
      |> Metadata.title("Transforms")

    text =
      [
        Text.text(["Some text.", "More text."]),
        Text.text(0, 30, "Arial Bold Italic")
        |> Font.font_family("Arial")
        |> Font.font_style(:italic)
        |> Font.font_weight(:bold),
        Text.text(0, 60, "Rotated")
        |> Text.rotate([0, 5, 10, 15, 20, 25, 30]),
        Text.text(0, 90, [
          "Text with a ",
          Text.tspan("span")
          |> Font.font_weight(:bold)
          |> Painting.fill(:powderblue),
          " in color."
        ])
        |> Painting.fill(:orchid)
      ]
      |> Element.group()
      |> Transform.translate(10, 200)
      |> Metadata.title("Text")

    svg =
      SvgBuilder.svg(300, 300, [shapes, paths, paintings, transforms, text])
      |> XmlBuilder.generate()

    File.write("tmp/test.svg", svg)
    {:ok, resp} = post("/?out=json", svg)
    %{"messages" => messages} = resp.body

    errors = Enum.filter(messages, fn %{"type" => type} -> type == "error" end)

    assert [] = errors
  end
end
