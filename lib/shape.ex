defmodule SvgBuilder.Shape do
  import XmlBuilder
  alias SvgBuilder.{Element, Units}

  @moduledoc """
  This module enables creation of basic shapes.

  """

  @doc """
  Create a rectangle element.

  x: The x-axis coordinate of the side of the rectangle which has the smaller
     x-axis coordinate value in the current user coordinate system.

  y: The y-axis coordinate of the side of the rectangle which has the smaller
     y-axis coordinate value in the current user coordinate system.

  width: Width of the rectangle.

  height: Height of the rectangle.

  children: List of child elements.
  """
  @spec rect(Units.len_t(), Units.len_t(), Units.len_t(), Units.len_t(), [Element.t()]) ::
          Element.t()
  def rect(x, y, width, height, children \\ []) do
    element(
      :rect,
      %{x: Units.len(x), y: Units.len(y), width: Units.len(width), height: Units.len(height)},
      children
    )
  end

  @doc """
  Create a rounded rectangle element.

  x: The x-axis coordinate of the side of the rectangle which has the smaller
     x-axis coordinate value in the current user coordinate system.

  y: The y-axis coordinate of the side of the rectangle which has the smaller
     y-axis coordinate value in the current user coordinate system.

  width: Width of the rectangle.

  height: Height of the rectangle.

  rx : The x-axis radius of the ellipse used to round off the corners of the rectangle.

  ry: The y-axis radius of the ellipse used to round off the corners of the rectangle.

  children: List of child elements.
  """
  @spec rounded_rect(
          Units.len_t(),
          Units.len_t(),
          Units.len_t(),
          Units.len_t(),
          Units.len_t(),
          Units.len_t(),
          [Element.t()]
        ) :: Element.t()
  def rounded_rect(x, y, width, height, rx, ry, children \\ []) do
    element(
      :rect,
      %{
        x: Units.len(x),
        y: Units.len(y),
        width: Units.len(width),
        height: Units.len(height),
        rx: Units.len(rx),
        ry: Units.len(ry)
      },
      children
    )
  end

  @doc """
  Create a circle element.

  cx: The x-axis coordinate of the center of the circle.

  cy: The y-axis coordinate of the center of the circle.

  r: Radius of the circle.

  children: List of child elements.
  """
  @spec circle(Units.len_t(), Units.len_t(), Units.len_t(), [Element.t()]) :: Element.t()
  def circle(cx, cy, r, children \\ []) do
    element(:circle, %{cx: Units.len(cx), cy: Units.len(cy), r: Units.len(r)}, children)
  end

  @doc """
  Create an ellipse element.

  cx: The x-axis coordinate of the center of the ellipse

  cy: The y-axis coordinate of the center of the ellipse

  rx: x-axis radius of the ellipse.

  ry: y-axir radius of the ellipse.

  children: List of child elements.
  """
  @spec ellipse(Units.len_t(), Units.len_t(), Units.len_t(), Units.len_t(), [Element.t()]) ::
          Element.t()
  def ellipse(cx, cy, rx, ry, children \\ []) do
    element(
      :ellipse,
      %{cx: Units.len(cx), cy: Units.len(cy), rx: Units.len(rx), ry: Units.len(ry)},
      children
    )
  end

  @doc """
  Create a line element.

   x1, y1 : coordinates of the start of the line.

   x2, y2 : coordinates of the end of the line.
  """
  @spec line(Units.len_t(), Units.len_t(), Units.len_t(), Units.len_t(), [Element.t()]) ::
          Element.t()
  def line(x1, y1, x2, y2, children \\ []) do
    element(
      :line,
      %{x1: Units.len(x1), y1: Units.len(y1), x2: Units.len(x2), y2: Units.len(y2)},
      children
    )
  end

  @doc """
  Create a polyline element.

  points : a list of x, y coordinates as tuples.

  ## Example

    iex> SvgBuilder.Shape.polyline([{0,0},{2,3},{3,4},{6,6}])
    {:polyline, %{points: "0, 0, 2, 3, 3, 4, 6, 6"}, []}

  """
  @spec polyline([{Units.len_t(), Units.len_t()}], [Element.t()]) :: Element.t()
  def polyline(points, children \\ []) do
    element(:polyline, %{points: points_to_string(points, "")}, children)
  end

  @doc """
  Create a polygon element.

  points : a list of x, y coordinates as tuples.

  ## Example

    iex> SvgBuilder.Shape.polygon([{0,0},{2,3},{3,4},{6,6}])
    {:polygon, %{points: "0, 0, 2, 3, 3, 4, 6, 6"}, []}

  """
  @spec polygon([{Units.len_t(), Units.len_t()}], [Element.t()]) :: Element.t()
  def polygon(points, children \\ []) do
    element(:polygon, %{points: points_to_string(points, "")}, children)
  end

  defp points_to_string([{x, y}], acc) do
    String.trim("#{acc} #{Units.len(x)}, #{Units.len(y)}")
  end

  defp points_to_string([{x, y} | points], acc) do
    points_to_string(points, "#{acc} #{Units.len(x)}, #{Units.len(y)},")
  end
end
