defmodule SvgBuilder.Painting do
  alias SvgBuilder.Element
  import SvgBuilder.Units

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


  def fill(element, fill_attrs) when is_map(fill_attrs) do
    element
    |> fill(Map.get(fill_attrs, :color, :black))
    |> fill_rule(Map.get(fill_attrs, :rule, :nonzero))
    |> fill_opacity(Map.get(fill_attrs, :opacity, 1))
  end

  def fill(element, fill) do
    Element.add_attribute(element, :fill, color(fill))
  end

  def fill_rule(element, rule) do
    Element.add_attribute(element, :"fill-rule", fill_rule(rule))
  end

  def fill_opacity(element, opacity) do
    Element.add_attribute(element, :"fill-opacity", inherit_opacity(opacity))
  end

  def stroke(element, stroke_attrs) when is_map(stroke_attrs) do
    element
    |> stroke(Map.get(stroke_attrs, :color, :none))
    |> stroke_width(Map.get(stroke_attrs, :width, 1))
    |> stroke_linecap(Map.get(stroke_attrs, :linecap, :butt))
    |> stroke_linejoin(Map.get(stroke_attrs, :linejoin, :miter))
    |> stroke_miterlimit(Map.get(stroke_attrs, :miterlimit, 4))
    |> stroke_dasharray(Map.get(stroke_attrs, :dasharray, :none))
    |> stroke_dashoffset(Map.get(stroke_attrs, :dashoffset, 0))
    |> stroke_opacity(Map.get(stroke_attrs, :opacity, 1))
  end

  def stroke(element, stroke) do
    Element.add_attribute(element, :stroke, color(stroke))
  end

  def stroke_width(element, width) do
    Element.add_attribute(element, :"stroke-width", inherit_length(width))
  end

  def stroke_linecap(element, linecap) when linecap in [:butt, :round, :square, :inherit] do
    Element.add_attribute(element, :"stroke-linecap", linecap)
  end

  def stroke_linejoin(element, linejoin) when linejoin in [:miter, :round, :bevel, :inherit] do
    Element.add_attribute(element, :"stroke-linejoin", linejoin)
  end

  def stroke_miterlimit(element, miterlimit) do
    Element.add_attribute(element, :"stroke-miterlimit", inherit_length(miterlimit))
  end

  def stroke_dasharray(element, dasharray) do
    Element.add_attribute(element, :"stroke-dasharray", dash_array(dasharray))
  end

  def stroke_dashoffset(element, offset) do
    Element.add_attribute(element, :"stroke-dashoffset", inherit_length(offset))
  end

  def stroke_opacity(element, opacity) do
    Element.add_attribute(element, :"stroke-opacity", inherit_opacity(opacity))
  end

  defp color(:none) do
    :none
  end

  defp color(:current) do
    :currentColor
  end

  defp color(:inherit) do
    :inherit
  end

  defp color(name) when name in @colornames do
    name
  end

  defp color({r, g, b}) do
    "rgb(#{r}, #{g}, #{b})"
  end

  defp fill_rule(rule) when rule in [:nonzero, :evenodd, :inherit] do
    "#{rule}"
  end

  defp inherit_opacity(:inherit) do
    :inherit
  end

  defp inherit_opacity(n) when is_number(n) do
    "#{n}"
  end

  defp inherit_length(:inherit) do
    :inherit
  end

  defp inherit_length(l) do
    l(l)
  end

  defp dash_array(:none) do
    :none
  end

  defp dash_array(:inherit) do
    :inherit
  end

  defp dash_array(dasharray) when is_list(dasharray) do
    dash_array_to_string(dasharray, "")
  end

  defp dash_array_to_string([x], acc) do
    String.trim("#{acc} #{l(x)}")
  end

  defp dash_array_to_string([x | rest], acc) do
    dash_array_to_string(rest, "#{acc} #{l(x)}")
  end
end
