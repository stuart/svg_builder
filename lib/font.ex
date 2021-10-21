defmodule SvgBuilder.Font do
  alias SvgBuilder.{Element, Units}

  @text_types ~w(altGlyph textPath text tref tspan)
  @font_styles ~w(normal italic oblique inherit)a
  @font_variants ~w(normal small-caps inherit)a
  @font_weights ~w(normal bold bolder lighter inherit)a
  @numeric_font_weights [100, 200, 300, 400, 500, 600, 700, 800, 900]
  @font_stretches ~w(normal wider narrower ultra-condensed extra-condensed condensed semi-condensed semi-expanded expanded extra-expanded ultra-expanded inherit)a
  @font_sizes ~w(xx-small x-small small medium large x-large xx-large larger smaller)a

  @type font_style_t() :: :normal | :italic | :oblique | :inherit
  @type font_variant_t() :: :normal | :"small-caps" | :inherit
  @type font_weight_t() :: :normal | :bold | :bolder | :lighter | :inherit
  @type numeric_font_weight_t() :: 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900
  @type font_stretches_t() ::
          :normal
          | :wider
          | :narrower
          | :"ultra-condensed"
          | :"extra-condensed"
          | :condensed
          | :"semi-condensed"
          | :"semi-expanded"
          | :expanded
          | :"extra-expanded"
          | :"ultra-expanded"
          | :inherit
  @type font_size_t() ::
          :"xx-small"
          | :"x-small"
          | :small
          | :medium
          | :large
          | :"x-large"
          | :"xx-large"
          | :larger
          | :smaller
          | integer
          | float

  @moduledoc """
    Handles all font related attributes.

    Most font attributes can only be applied to the text type elements:
    #{inspect(@text_types)}

    https://www.w3.org/TR/SVG11/fonts.html
  """

  @doc """
    Set the font on a text type element.

    Font can be specified as a string font specification or as a map.

    The map to set font attributes may have the following keys:
    `:family`, `:style`, `:variant`, `:weight`, `:stretch`, `:size` and `:size_adjust`

    See the various individual functions for what values are allowed for these keys.

    ## Example

      iex>Text.text("Some text") |> Font.font("bold italic large Palatino, serif")
      {"text", %{font: "bold italic large Palatino, serif"}, "Some text"}

      iex>Text.text("Some text") |> Font.font(%{family: "Palantino, serif", weight: :bold, style: :italic, size: :large})
      {"text", %{"font-family": "Palantino, serif", "font-size": :large, "font-style": :italic, "font-weight": :bold}, "Some text"}

  """
  @spec font(
          Element.t(),
          %{
            optional(:family) => binary,
            optional(:style) => font_style_t,
            optional(:variant) => font_variant_t,
            optional(:weight) => font_weight_t | numeric_font_weight_t,
            optional(:stretch) => font_stretches_t,
            optional(:size) => font_size_t,
            optional(:size_adjust) => number | :inherit | :none
          }
          | binary
        ) :: Element.t()
  def font(element, font) when is_binary(font) do
    add_text_attribute(element, :font, font)
  end

  def font(element, %{} = options) do
    element
    |> apply_unless_nil(Map.get(options, :family), &font_family/2)
    |> apply_unless_nil(Map.get(options, :style), &font_style/2)
    |> apply_unless_nil(Map.get(options, :variant), &font_variant/2)
    |> apply_unless_nil(Map.get(options, :weight), &font_weight/2)
    |> apply_unless_nil(Map.get(options, :stretch), &font_stretch/2)
    |> apply_unless_nil(Map.get(options, :size), &font_size/2)
    |> apply_unless_nil(Map.get(options, :size_adjust), &font_size_adjust/2)
  end

  defp apply_unless_nil(element, nil, _function) do
    element
  end

  defp apply_unless_nil(element, value, function) do
    function.(element, value)
  end

  @doc """
    Set the font-family attribute on a text element.
  """
  @spec font_family(Element.t(), binary) :: Element.t()
  def font_family(element, family) do
    add_text_attribute(element, :"font-family", family)
  end

  @doc """
    Set the font-style attribute on a text element.

    Allowed values are: `#{inspect(@font_styles)}`
  """
  @spec font_style(Element.t(), font_style_t) :: Element.t()
  def font_style(element, style) when style in @font_styles do
    add_text_attribute(element, :"font-style", style)
  end

  @doc """
    Set the font-variant attribute on a text element.

    Allowed values are: `#{inspect(@font_variants)}`
  """
  @spec font_variant(Element.t(), font_variant_t) :: Element.t()
  def font_variant(element, variant) when variant in @font_variants do
    add_text_attribute(element, :"font-variant", variant)
  end

  @doc """
    Set the font-weight attribute on a text element.

    Allowed values are: `#{inspect(@font_weights)}` or the
    numeric values: `#{inspect(@numeric_font_weights)}`
  """
  @spec font_weight(Element.t(), font_weight_t | numeric_font_weight_t) :: Element.t()
  def font_weight(element, weight)
      when weight in @font_weights do
    add_text_attribute(element, :"font-weight", weight)
  end

  def font_weight(element, weight)
      when weight in @numeric_font_weights do
    add_text_attribute(element, :"font-weight", "#{weight}")
  end

  @doc """
    Set the font-stretch attribute on a text element.

    Allowed values are: `#{inspect(@font_variants)}`
  """
  @spec font_stretch(Element.t(), font_stretches_t) :: Element.t()
  def font_stretch(element, stretch) when stretch in @font_stretches do
    add_text_attribute(element, :"font-stretch", stretch)
  end

  @doc """
    Set the font-size attribute on a text element.

    Allowed values are a numeric point size or one of `#{inspect(@font_sizes)}`
  """
  @spec font_size(Element.t(), font_size_t) :: Element.t()
  def font_size(element, size) when size in @font_sizes do
    add_text_attribute(element, :"font-size", size)
  end

  def font_size(element, size) do
    add_text_attribute(element, :"font-size", Units.len(size))
  end

  @doc """
    Set the font-size-adjust attribute on a text element.

    May be a number or one of `[:inherit, :none]`
  """
  @spec font_size_adjust(Element.t(), number | :inherit | :none) :: Element.t()
  def font_size_adjust(element, size) when size in [:inherit, :none] do
    add_text_attribute(element, :"font-size-adjust", size)
  end

  def font_size_adjust(element, size) do
    add_text_attribute(element, :"font-size-adjust", Units.number(size))
  end

  defp add_text_attribute({type, _, _} = element, attribute, value) when type in @text_types do
    Element.add_attribute(element, attribute, value)
  end

  defp add_text_attribute({type, _, _}, attribute, _) do
    raise ArgumentError, "Cannot set #{attribute} on element of type: #{type}"
  end
end
