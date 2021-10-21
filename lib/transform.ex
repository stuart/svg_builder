defmodule SvgBuilder.Transform do
  alias SvgBuilder.Element

  @moduledoc """
  Apply transforms to SVG elements.
  """

  @spec translate(Element.t(), number, number) :: Element.t()
  def translate(element, tx, ty) do
    add_transform(element, "translate(#{tx},#{ty})")
  end

  @spec matrix(Element.t(), {number, number, number, number, number, number}) :: Element.t()
  def matrix(element, {a, b, c, d, e, f}) do
    add_transform(element, "matrix(#{a},#{b},#{c},#{d},#{e},#{f})")
  end

  @spec scale(Element.t(), number, number) :: Element.t()
  def scale(element, sx, sy) do
    add_transform(element, "scale(#{sx},#{sy})")
  end

  @spec rotate(Element.t(), number) :: Element.t()
  def rotate(element, angle) do
    add_transform(element, "rotate(#{angle})")
  end

  @spec rotate(Element.t(), number, number, number) :: Element.t()
  def rotate(element, angle, cx, cy) do
    add_transform(element, "rotate(#{angle}, #{cx}, #{cy})")
  end

  @spec skew_x(Element.t(), number) :: Element.t()
  def skew_x(element, angle) do
    add_transform(element, "skewX(#{angle})")
  end

  @spec skew_y(Element.t(), number) :: Element.t()
  def skew_y(element, angle) do
    add_transform(element, "skewY(#{angle})")
  end

  defp add_transform({type, attrs, children}, transform) do
    t =
      [Map.get(attrs, :transform, ""), transform]
      |> Enum.join(" ")
      |> String.trim()

    {type, Map.put(attrs, :transform, t), children}
  end
end
