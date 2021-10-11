defmodule SvgBuilderTest do
  use ExUnit.Case
  doctest SvgBuilder

  use SvgBuilder
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://validator.w3.org/nu/")

  plug(Tesla.Middleware.Headers, [
    {"content-type", "image/svg+xml; charset=utf-8"},
    {"User-Agent", "SvgBuilder/1.0"}
  ])

  plug(Tesla.Middleware.JSON)

  test "creates a valid SVG file" do
    r =
      Shape.rect(10, 10, 100, 100)
      |> Painting.fill(:red)
      |> Painting.stroke(:blue)
      |> Transform.transform([Transform.rotate(30.0)])

    l = Shape.line("30em", {30, :em}, 45.4, 45.6)

    p =
      Path.path()
      |> Path.move(10.2, 40.3)
      |> Path.line_to(21, 21)
      |> Path.vertical_rel(3)

    svg =
      SvgBuilder.svg(200, 200, [r, l, p])
      |> XmlBuilder.generate()

    IO.puts svg
    {:ok, resp} = post("/?out=json", svg)
    %{"messages" => messages} = resp.body

    errors = Enum.filter(messages, fn %{"type" => type} -> type == "error" end)

    assert [] = errors
  end
end
