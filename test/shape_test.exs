defmodule Shape.ShapeTest do
  use ExUnit.Case
  use SvgBuilder

  doctest Shape

  test :rect do
    assert {:rect, %{x: "10", y: "10", width: "100", height: "100"}, []} ==
             Shape.rect(10, 10, 100, 100)
  end

  test "rounded_rect" do
    assert {:rect, %{x: "10", y: "10", width: "100", height: "100", rx: "2", ry: "3"}, []} ==
             Shape.rounded_rect(10, 10, 100, 100, 2, 3)
  end

  test :circle do
    assert {:circle, %{cx: "3", cy: "4", r: "5"}, []} == Shape.circle(3, 4, 5)
  end

  test :ellipse do
    assert {:ellipse, %{cx: "1", cy: "2", rx: "3", ry: "4"}, []} ==
             Shape.ellipse(1, 2, 3, 4)
  end

  test :line do
    assert {:line, %{x1: "1", y1: "2", x2: "3", y2: "4"}, []} == Shape.line(1, 2, 3, 4)
  end

  test :polyline do
    assert {:polyline, %{points: "10, 20, 10, 30, 40, 50"}, []} ==
             Shape.polyline([{10, 20}, {10, 30}, {40, 50}])
  end
end
