defmodule SvgBuilder.FontTest do
  use ExUnit.Case
  use SvgBuilder

  doctest Font

  test "font-family" do
    t =
      Text.text("Some text")
      |> Font.font_family("Sans")

    assert {:text, %{"font-family": "Sans"}, "Some text"} = t
  end

  test "font-style" do
    t =
      Text.text("Some text")
      |> Font.font_style(:italic)

    assert {:text, %{"font-style": :italic}, "Some text"} = t
  end

  test "font-variant" do
    t =
      Text.text("Some text")
      |> Font.font_variant(:"small-caps")

    assert {:text, %{"font-variant": :"small-caps"}, "Some text"} = t
  end

  test "font-weight" do
    t =
      Text.text("Some text")
      |> Font.font_weight(:bold)

    assert {:text, %{"font-weight": :bold}, "Some text"} = t
  end

  test "font-weight with number" do
    t =
      Text.text("Some text")
      |> Font.font_weight(300)

    assert {:text, %{"font-weight": "300"}, "Some text"} = t
  end

  test "font-stretch" do
    t =
      Text.text("Some text")
      |> Font.font_stretch(:wider)

    assert {:text, %{"font-stretch": :wider}, "Some text"} = t
  end

  test "font-size" do
    t =
      Text.text("Some text")
      |> Font.font_size(:smaller)

    assert {:text, %{"font-size": :smaller}, "Some text"} = t
  end

  test "font-size as a length" do
    t =
      Text.text("Some text")
      |> Font.font_size(23)

    assert {:text, %{"font-size": "23"}, "Some text"} = t
  end

  test "font-size-adjust with a number" do
    t =
      Text.text("Some text")
      |> Font.font_size_adjust(10.3)

    assert {:text, %{"font-size-adjust": "10.3"}, "Some text"} = t
  end

  test "font-size-adjust" do
    t =
      Text.text("Some text")
      |> Font.font_size_adjust(:inherit)

    assert {:text, %{"font-size-adjust": :inherit}, "Some text"} = t
  end

  test "font" do
    t =
      Text.text("Some text")
      |> Font.font(%{
        family: "Sans",
        style: :normal,
        variant: :"small-caps",
        weight: 400,
        stretch: :wider,
        size: 100,
        size_adjust: 0
      })

    assert {
             :text,
             %{
               "font-family": "Sans",
               "font-size": "100",
               "font-stretch": :wider,
               "font-style": :normal,
               "font-variant": :"small-caps",
               "font-weight": "400",
               "font-size-adjust": "0"
             },
             "Some text"
           } = t
  end

  test "font with no attributes" do
    t =
      Text.text("Some text")
      |> Font.font(%{})

    assert {
             :text,
             %{},
             "Some text"
           } = t
  end

  test "Cannot apply font attributes to non-test content element" do
    assert_raise ArgumentError, fn ->
      Shape.rect(0, 0, 10, 10)
      |> Font.font_size_adjust(:inherit)
    end
  end
end
