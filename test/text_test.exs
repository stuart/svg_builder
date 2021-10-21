defmodule SvgBuilder.TextTest do
  use ExUnit.Case
  use SvgBuilder

  test "A basic text element" do
    assert {"text", %{}, "This is some text."} = Text.text("This is some text.")
  end

  test "Text with a position" do
    assert {"text", %{x: "10", y: "10"}, "This is some text."} =
             Text.text(10, 10, "This is some text.")
  end

  test "Text with lists of coordinates" do
    assert {"text", %{x: "10 20 30", y: "10 20 30"}, "This is some text."} =
             Text.text([10, 20, 30], [10, 20, 30], "This is some text.")
  end

  test "Text with dx and dy" do
    assert {"text", %{dx: "3", dy: "3"}, "This is some text."} =
             Text.text(10, 10, 3, 3, "This is some text.")
  end

  test "Text with multiple parts" do
    assert {"text", %{}, [{nil, nil, "This is some text."}, {nil, nil, "And some more text."}]} =
             Text.text(["This is some text.", "And some more text."])
  end

  test "tspan" do
    assert {"tspan", %{}, "This is a span."} = Text.tspan("This is a span.")
  end

  test "tspan with x and y" do
    assert {"tspan", %{x: "20px", y: "30px"}, "This is a span."} =
             Text.tspan({20, :px}, {30, :px}, "This is a span.")
  end

  test "tspan with dx and dy" do
    assert {"tspan", %{dx: "3", dy: "3"}, "This is a span."} =
             Text.tspan(10, 10, 3, 3, "This is a span.")
  end

  test "Nested text with tspans" do
    assert {"text", %{},
            [
              {nil, nil, "Some text"},
              {"tspan", %{}, "Span one"},
              {"tspan", %{},
               [{nil, nil, "Span two"}, {"tspan", %{}, "Nested span"}, {nil, nil, "More text."}]}
            ]} =
             Text.text([
               "Some text",
               Text.tspan("Span one"),
               Text.tspan(["Span two", Text.tspan("Nested span"), "More text."])
             ])
  end

  test "Invalid text elements are removed" do
    assert {"text", %{}, [{nil, nil, "Some text"}]} =
             Text.text(["Some text", Shape.circle(10, 10, 1)])
  end

  test "Rotation of text" do
    t =
      Text.text("This is some text.")
      |> Text.rotate(5.46)

    assert {"text", %{rotate: "5.46"}, "This is some text."} = t
  end

  test "Rotation of text with a list" do
    t =
      Text.text("This is some text.")
      |> Text.rotate([10, 30, 20])

    assert {"text", %{rotate: "10 30 20"}, "This is some text."} = t
  end
end
