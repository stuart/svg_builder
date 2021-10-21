defmodule SvgBuilder.Painting do
  alias SvgBuilder.Element
  alias SvgBuilder.Units

  @moduledoc """
  Handles filling, stroking and marker symbols.

  https://www.w3.org/TR/SVG11/painting.html

  Fill and stroke can be assigned `t:paint_t/0` type values.
  The meanings of these values are as follows:

  * `:current` : Use the currentColor set in the document.
  * `:inherit` : Use the parent element's value for paint.
  * `:none` : No paint.
  *  atom : Use one of the standard color names. `t:color_t/0`
  *  `"url(...)"` : Set the paint from a URL resource.
  *  `"icc-color(...)"` : Set to an ICC color profile.
  * `{r, g, b}` : Set the red. green and blue values either as integers from 0 to 255 or floats from 0.0 to 1.0.
  * `t:SvgBuilder.Element.t/0` : Set the paint from another element, must be a linearGradient, radialGradient or pattern element.

  """

  @colornames ~w(aliceblue antiquewhite aqua aquamarine azure beige bisque black
  blanchedalmond blue blueviolet brown burlywood cadetblue chartreuse chocolate
  coral cornflowerblue cornsilk crimson cyan darkblue darkcyan darkgoldenrod
  darkgray darkgreen darkgrey darkkhaki darkmagenta darkolivegreen darkorange
  darkorchid darkred darksalmon darkseagreen darkslateblue darkslategray
  darkslategrey darkturquoise darkviolet deeppink deepskyblue dimgray dimgrey
  dodgerblue firebrick floralwhite forestgreen fuchsia gainsboro ghostwhite gold
  goldenrod gray grey green greenyellow honeydew hotpink indianred indigo ivory
  khaki lavender lavenderblush lawngreen lemonchiffon lightblue lightcoral
  lightcyan lightgoldenrodyellow lightgray lightgreen lightgrey lightpink
  lightsalmon lightseagreen lightskyblue lightslategray lightslategrey
  lightsteelblue lightyellow lime limegreen linen magenta maroon
  mediumaquamarine mediumblue mediumorchid mediumpurple mediumseagreen
  mediumslateblue mediumspringgreen mediumturquoise mediumvioletred midnightblue
  mintcream mistyrose moccasin navajowhite navy oldlace olive olivedrab orange
  orangered orchid palegoldenrod palegreen paleturquoise palevioletred
  papayawhip peachpuff peru pink plum powderblue purple red rosybrown royalblue
  saddlebrown salmon sandybrown seagreen seashell sienna silver skyblue
  slateblue slategray slategrey snow springgreen steelblue tan teal thistle
  tomato turquoise violet wheat white whitesmoke yellow yellowgreen)a

  @type color_t() ::
          :aliceblue
          | :antiquewhite
          | :aqua
          | :aquamarine
          | :azure
          | :beige
          | :bisque
          | :black
          | :blanchedalmond
          | :blue
          | :blueviolet
          | :brown
          | :burlywood
          | :cadetblue
          | :chartreuse
          | :chocolate
          | :coral
          | :cornflowerblue
          | :cornsilk
          | :crimson
          | :cyan
          | :darkblue
          | :darkcyan
          | :darkgoldenrod
          | :darkgray
          | :darkgreen
          | :darkgrey
          | :darkkhaki
          | :darkmagenta
          | :darkolivegreen
          | :darkorange
          | :darkorchid
          | :darkred
          | :darksalmon
          | :darkseagreen
          | :darkslateblue
          | :darkslategray
          | :darkslategrey
          | :darkturquoise
          | :darkviolet
          | :deeppink
          | :deepskyblue
          | :dimgray
          | :dimgrey
          | :dodgerblue
          | :firebrick
          | :floralwhite
          | :forestgreen
          | :fuchsia
          | :gainsboro
          | :ghostwhite
          | :gold
          | :goldenrod
          | :gray
          | :grey
          | :green
          | :greenyellow
          | :honeydew
          | :hotpink
          | :indianred
          | :indigo
          | :ivory
          | :khaki
          | :lavender
          | :lavenderblush
          | :lawngreen
          | :lemonchiffon
          | :lightblue
          | :lightcoral
          | :lightcyan
          | :lightgoldenrodyellow
          | :lightgray
          | :lightgreen
          | :lightgrey
          | :lightpink
          | :lightsalmon
          | :lightseagreen
          | :lightskyblue
          | :lightslategray
          | :lightslategrey
          | :lightsteelblue
          | :lightyellow
          | :lime
          | :limegreen
          | :linen
          | :magenta
          | :maroon
          | :mediumaquamarine
          | :mediumblue
          | :mediumorchid
          | :mediumpurple
          | :mediumseagreen
          | :mediumslateblue
          | :mediumspringgreen
          | :mediumturquoise
          | :mediumvioletred
          | :midnightblue
          | :mintcream
          | :mistyrose
          | :moccasin
          | :navajowhite
          | :navy
          | :oldlace
          | :olive
          | :olivedrab
          | :orange
          | :orangered
          | :orchid
          | :palegoldenrod
          | :palegreen
          | :paleturquoise
          | :palevioletred
          | :papayawhip
          | :peachpuff
          | :peru
          | :pink
          | :plum
          | :powderblue
          | :purple
          | :red
          | :rosybrown
          | :royalblue
          | :saddlebrown
          | :salmon
          | :sandybrown
          | :seagreen
          | :seashell
          | :sienna
          | :silver
          | :skyblue
          | :slateblue
          | :slategray
          | :slategrey
          | :snow
          | :springgreen
          | :steelblue
          | :tan
          | :teal
          | :thistle
          | :tomato
          | :turquoise
          | :violet
          | :wheat
          | :white
          | :whitesmoke
          | :yellow
          | :yellowgreen

  @type paint_t() ::
          :inherit
          | :none
          | :current
          | color_t()
          | {non_neg_integer(), non_neg_integer(), non_neg_integer()}
          | {float(), float(), float()}
          | binary()
          | Element.t()

  @doc """
  Set the "fill" attributes of an element.

  When called with a map the attributes set are `:color, :rule, :opacity`

  When called with a `t:paint_t/0` value, then just the "fill" attribute is set.
  See above for paint options.

  ## Examples

      iex> rect = SvgBuilder.Shape.rect(0,0,10,10)
      {"rect", %{height: "10", width: "10", x: "0", y: "0"}, []}
      iex> SvgBuilder.Painting.fill(rect, :red)
      {"rect", %{fill: :red, height: "10", width: "10", x: "0", y: "0"}, []}
      iex> SvgBuilder.Painting.fill(rect, {123,45,3})
      {"rect", %{fill: "rgb(123, 45, 3)", height: "10", width: "10", x: "0", y: "0"},[]}
      iex>SvgBuilder.Painting.fill(rect, %{color: :inherit, opacity: 0.5, rule: :evenodd})
      {"rect", %{fill: "rgb(123, 45, 3)", height: "10", width: "10", x: "0", y: "0"},[]}
      {"rect",
        %{
            fill: :inherit,
            "fill-opacity": "0.5",
            "fill-rule": "evenodd",
            height: "10",
            width: "10",
            x: "0",
            y: "0"
          }, []}

  """
  @spec fill(Element.t(), %{} | paint_t) :: Element.t()
  def fill(element, fill_attrs) when is_map(fill_attrs) do
    element
    |> apply_unless_nil(Map.get(fill_attrs, :color), &fill/2)
    |> apply_unless_nil(Map.get(fill_attrs, :rule), &fill_rule/2)
    |> apply_unless_nil(Map.get(fill_attrs, :opacity), &fill_opacity/2)
  end

  def fill(element, fill) do
    Element.add_attribute(element, :fill, paint(fill))
  end

  @doc """
  Set the "fill-rule" attribute for an element. This sets the algorithm for determining which
  parts of the canvas are included inside the shape.
  See: https://www.w3.org/TR/SVG11/painting.html#FillProperties

  Allowed values are:

  * `:non_zero`
  * `:evenodd`
  * `:inherit`
  """
  @spec fill_rule(Element.t(), :non_zero | :evenodd | :inherit) :: Element.t()
  def fill_rule(element, rule) do
    Element.add_attribute(element, :"fill-rule", fill_rule(rule))
  end

  @doc """
  Sets the "fill-opacity" attribute on an element.

  Opacity may be one of:
  * nil
  * `:inherit`
  * a float from 0.0 to 1.0

  """
  @spec fill_opacity(Element.t(), nil | :inherit | float) :: Element.t()
  def fill_opacity(element, opacity) do
    Element.add_attribute(element, :"fill-opacity", opacity(opacity))
  end

  @doc """
  Set the stroke attributes on an element.

  When called with a map of attributes use the following keys: `[:color, :width,
   :linecap, :linejoin, :mitrelimit, :dasharray, :dashoffset, :opacity]` to
   set various stroke attributes.

  When called with a `t:paint_t/0` type it just sets the "stroke" attribute on
  the element.
  """
  @spec stroke(Element.t(), map | paint_t) :: Element.t()
  def stroke(element, stroke_attrs) when is_map(stroke_attrs) do
    element
    |> apply_unless_nil(Map.get(stroke_attrs, :color), &stroke/2)
    |> apply_unless_nil(Map.get(stroke_attrs, :width), &stroke_width/2)
    |> apply_unless_nil(Map.get(stroke_attrs, :linecap), &stroke_linecap/2)
    |> apply_unless_nil(Map.get(stroke_attrs, :linejoin), &stroke_linejoin/2)
    |> apply_unless_nil(Map.get(stroke_attrs, :miterlimit), &stroke_miterlimit/2)
    |> apply_unless_nil(Map.get(stroke_attrs, :dasharray), &stroke_dasharray/2)
    |> apply_unless_nil(Map.get(stroke_attrs, :dashoffset), &stroke_dashoffset/2)
    |> apply_unless_nil(Map.get(stroke_attrs, :opacity), &stroke_opacity/2)
  end

  def stroke(element, stroke) do
    Element.add_attribute(element, :stroke, paint(stroke))
  end

  @doc """
  Sets the "stroke-width" attribute on an element.

  Can be set to a number or `:inherit`.
  """
  @spec stroke_width(Element.t(), number | :inherit) :: Element.t()
  def stroke_width(element, width) do
    Element.add_attribute(element, :"stroke-width", inherit_length(width))
  end

  @doc """
  Sets the "stroke-linecap" attribute on an element.

  Allowable values are `:butt`, `:round`, `:square` and `:inherit`
  """
  @spec stroke_linecap(Element.t(), :butt | :round | :square | :inherit) :: Element.t()
  def stroke_linecap(element, linecap) when linecap in [:butt, :round, :square, :inherit] do
    Element.add_attribute(element, :"stroke-linecap", linecap)
  end

  @doc """
  Sets the "stroke-linejoin" attribute on an element.

  Allowable values are `:miter`, `:round`, `:bevel` and `:inherit`
  """
  @spec stroke_linejoin(Element.t(), :miter | :round | :bevel | :inherit) :: Element.t()
  def stroke_linejoin(element, linejoin) when linejoin in [:miter, :round, :bevel, :inherit] do
    Element.add_attribute(element, :"stroke-linejoin", linejoin)
  end

  @doc """
  Sets the "stroke-miterlimit" attribute on an element.

  Allowable values are a number or `:inherit`
  """
  @spec stroke_miterlimit(Element.t(), number | :inherit) :: Element.t()
  def stroke_miterlimit(element, miterlimit) do
    Element.add_attribute(element, :"stroke-miterlimit", inherit_length(miterlimit))
  end

  @doc """
  Sets the "stroke-dasharray" attribute on an element.

  The `dasharray` argument can be `:none`, `:inherit` or a list of
  dash lengths. Note that SVG will duplicate the dash array if an odd number
  of elements are in the list.
  """
  @spec stroke_dasharray(Element.t(), [number] | :none | :inherit) :: Element.t()
  def stroke_dasharray(element, dasharray) do
    Element.add_attribute(element, :"stroke-dasharray", dash_array(dasharray))
  end

  @doc """
  Sets the "stroke-dashoffset" attribute on an element.

  The offset may be either `:inherit` or a number.
  """
  @spec stroke_dashoffset(Element.t(), number | :inherit) :: Element.t()
  def stroke_dashoffset(element, offset) do
    Element.add_attribute(element, :"stroke-dashoffset", inherit_length(offset))
  end

  @doc """
  Sets the "stroke-opacity" attribute on an element.

  The opacity may be either `nil`, `:inherit` or a float from 0.0 to 1.0.
  """
  @spec stroke_opacity(Element.t(), float | :inherit | nil) :: Element.t()
  def stroke_opacity(element, opacity) do
    Element.add_attribute(element, :"stroke-opacity", opacity(opacity))
  end

  defp paint(:current) do
    :currentColor
  end

  defp paint(paint) when paint in [:none, :inherit] do
    paint
  end

  defp paint(paint) when paint in @colornames do
    paint
  end

  defp paint(<<"url(", _::binary>> = paint) do
    paint
  end

  defp paint(<<"icc-color(", _::binary>> = paint) do
    paint
  end

  defp paint({type, %{id: id}, []})
       when type in ["linearGradient", "radialGradient", "pattern"] do
    "url(##{id})"
  end

  defp paint({r, g, b}) when is_number(r) and is_number(g) and is_number(b) do
    "rgb(#{r}, #{g}, #{b})"
  end

  defp paint(paint) do
    raise ArgumentError, "Invalid paint: #{inspect(paint)}"
  end

  defp fill_rule(rule) when rule in [:nonzero, :evenodd, :inherit] do
    "#{rule}"
  end

  defp opacity(nil) do
    nil
  end

  defp opacity(:inherit) do
    :inherit
  end

  defp opacity(n) when is_number(n) do
    Units.number(n)
  end

  defp inherit_length(:inherit) do
    :inherit
  end

  defp inherit_length(l) do
    Units.len(l)
  end

  defp dash_array(:none) do
    :none
  end

  defp dash_array(:inherit) do
    :inherit
  end

  defp dash_array(dasharray) do
    Units.length_list(dasharray)
  end

  defp apply_unless_nil(element, nil, _function) do
    element
  end

  defp apply_unless_nil(element, value, function) do
    function.(element, value)
  end
end
