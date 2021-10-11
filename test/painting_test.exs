defmodule SvgBuilder.PaintingTest do
  use ExUnit.Case
  use SvgBuilder

  test "fill none" do
    r =
      Shape.rect(10, 10, 20, 20)
      |> Painting.fill(:none)

    assert {"rect", %{fill: :none}, []} = r
  end

  test "fill currentColor" do
    r =
      Shape.rect(10, 10, 20, 20)
      |> Painting.fill(:current)

    assert {"rect", %{fill: :currentColor}, []} = r
  end

  test "fill inherit" do
    r =
      Shape.rect(10, 10, 20, 20)
      |> Painting.fill(:inherit)

    assert {"rect", %{fill: :inherit}, []} = r
  end

  test "fill named color" do
    r =
      Shape.rect(10, 10, 20, 20)
      |> Painting.fill(:lightgray)

    assert {"rect", %{fill: :lightgray}, []} = r
  end

  test "fill with a color not named" do
    assert_raise FunctionClauseError, fn ->
      Shape.rect(10, 10, 20, 20)
      |> Painting.fill(:burple)
    end
  end

  test "fill with RGB" do
    r =
      Shape.rect(10, 10, 20, 20)
      |> Painting.fill({100, 30, 40})

    assert {"rect", %{fill: "rgb(100, 30, 40)"}, []} = r
  end

  test "fill with defaults" do
    {"rect", attrs, []} =
      Shape.rect(10, 10, 20, 20)
      |> Painting.fill(%{})

    assert %{
             fill: :black,
             "fill-opacity": "1",
             "fill-rule": "nonzero",
             height: "20",
             width: "20",
             x: "10",
             y: "10"
           } == attrs
  end

  test "fill with attributes" do
    {"rect", attrs, []} =
      Shape.rect(10, 10, 20, 20)
      |> Painting.fill(%{color: {255, 30, 128}, rule: :evenodd, opacity: 0.6})

    assert %{
             fill: "rgb(255, 30, 128)",
             "fill-opacity": "0.6",
             "fill-rule": "evenodd",
             height: "20",
             width: "20",
             x: "10",
             y: "10"
           } == attrs
  end

  test "fill_rule" do
    r =
      Shape.rect(10, 10, 20, 20)
      |> Painting.fill_rule(:evenodd)

    assert {"rect", %{"fill-rule": "evenodd"}, []} = r
  end

  test "fill_opacity" do
    r =
      Shape.rect(10, 10, 20, 20)
      |> Painting.fill_opacity(0.5)

    assert {"rect", %{"fill-opacity": "0.5"}, []} = r
  end

  test "stroke with color" do
    r =
      Shape.rect(10, 10, 20, 20)
      |> Painting.stroke({255, 34, 23})

    assert {"rect", %{stroke: "rgb(255, 34, 23)"}, []} = r
  end

  test "stroke currentColor" do
    r =
      Shape.rect(10, 10, 20, 20)
      |> Painting.stroke(:current)

    assert {"rect", %{stroke: :currentColor}, []} = r
  end

  test "stroke with named color" do
    r =
      Shape.rect(10, 10, 20, 20)
      |> Painting.stroke(:gold)

    assert {"rect", %{stroke: :gold}, []} = r
  end

  test "default stroke" do
    {"rect", attrs, []} =
      Shape.rect(10, 10, 20, 20)
      |> Painting.stroke(%{})

    assert %{
             stroke: :none,
             height: "20",
             "stroke-dasharray": :none,
             "stroke-dashoffset": "0",
             "stroke-linecap": :butt,
             "stroke-linejoin": :miter,
             "stroke-miterlimit": "4",
             "stroke-opacity": "1",
             "stroke-width": "1",
             width: "20",
             x: "10",
             y: "10"
           } == attrs
  end

  test "stroke with stroke attributes map" do
    {"rect", attrs, []} =
      Shape.rect(10, 10, 20, 20)
      |> Painting.stroke(%{
        color: :blue,
        width: 2,
        opacity: 0.5,
        linecap: :round,
        miter: :round,
        miterlimit: 3,
        dasharray: [3, 2],
        dashoffset: 1
      })

    assert %{
             height: "20",
             stroke: :blue,
             "stroke-dasharray": "3 2",
             "stroke-dashoffset": "1",
             "stroke-linecap": :round,
             "stroke-linejoin": :miter,
             "stroke-miterlimit": "3",
             "stroke-opacity": "0.5",
             "stroke-width": "2",
             width: "20",
             x: "10",
             y: "10"
           } == attrs
  end

  test "stroke_width" do
    r =
      Shape.rect(10, 10, 20, 20)
      |> Painting.stroke_width("3px")

    assert {"rect", %{"stroke-width": "3px"}, []} = r
  end

  test "stroke_linecap" do
    r =
      Shape.rect(10, 10, 20, 20)
      |> Painting.stroke_linecap(:round)

    assert {"rect", %{"stroke-linecap": :round}, []} = r
  end

  test "stroke_linejoin" do
    r =
      Shape.rect(10, 10, 20, 20)
      |> Painting.stroke_linejoin(:round)

    assert {"rect", %{"stroke-linejoin": :round}, []} = r
  end

  test "stroke_miterlimit" do
    r =
      Shape.rect(10, 10, 20, 20)
      |> Painting.stroke_miterlimit(4)

    assert {"rect", %{"stroke-miterlimit": "4"}, []} = r
  end

  test "stroke_dasharray" do
    r =
      Shape.rect(10, 10, 20, 20)
      |> Painting.stroke_dasharray([2, 3, 4, 3])

    assert {"rect", %{"stroke-dasharray": "2 3 4 3"}, []} = r
  end

  test "stroke_dashoffset" do
    r =
      Shape.rect(10, 10, 20, 20)
      |> Painting.stroke_dashoffset({4, :px})

    assert {"rect", %{"stroke-dashoffset": "4px"}, []} = r
  end

  test "stroke_opacity" do
    r =
      Shape.rect(10, 10, 20, 20)
      |> Painting.stroke_opacity(0.1)

    assert {"rect", %{"stroke-opacity": "0.1"}, []} = r
  end
end
