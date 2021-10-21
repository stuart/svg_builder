defmodule SvgBuilder.Transform do
  alias SvgBuilder.Element

  @moduledoc """
  Apply transforms to SVG elements.

  These add or append to the "transform" attribute
  on an element.
  """

  @doc """
  Apply a translation to an element.
  """
  @spec translate(Element.t(), number, number) :: Element.t()
  def translate(element, tx, ty) do
    add_transform(element, "translate(#{tx},#{ty})")
  end

  @doc """
  Apply a matrix transform to an element.

  Given `{a, b, c, d, e, f}` the transformation is defined by the matrix:
    | a c e |
    | b d f |
    | 0 0 1 |

  https://www.w3.org/TR/SVG11/coords.html#TransformMatrixDefined
  """
  @spec matrix(Element.t(), {number, number, number, number, number, number}) :: Element.t()
  def matrix(element, {a, b, c, d, e, f}) do
    add_transform(element, "matrix(#{a},#{b},#{c},#{d},#{e},#{f})")
  end

  @doc """
  Apply a scale transformation to the element.
  """
  @spec scale(Element.t(), number, number) :: Element.t()
  def scale(element, sx, sy) do
    add_transform(element, "scale(#{sx},#{sy})")
  end

  @doc """
  Apply a rotation to the element.

  Angle is in degrees.
  """
  @spec rotate(Element.t(), number) :: Element.t()
  def rotate(element, angle) do
    add_transform(element, "rotate(#{angle})")
  end

  @doc """
  Apply a rotation to an element around a defined center point.

  Angle is in degrees.
  """
  @spec rotate(Element.t(), number, number, number) :: Element.t()
  def rotate(element, angle, cx, cy) do
    add_transform(element, "rotate(#{angle}, #{cx}, #{cy})")
  end

  @doc """
  Apply a skew on the X axis to the element.
  """
  @spec skew_x(Element.t(), number) :: Element.t()
  def skew_x(element, angle) do
    add_transform(element, "skewX(#{angle})")
  end

  @doc """
  Apply a skew on the Y axis to the element. 
  """
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
