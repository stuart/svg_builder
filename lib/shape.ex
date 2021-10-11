defmodule SvgBuilder.Shape do
  import XmlBuilder
  import SvgBuilder.Units

  def rect(x, y, width, height, children \\ []) do
    element("rect", %{x: l(x), y: l(y), width: l(width), height: l(height)}, children)
  end

  def rounded_rect(x, y, width, height, rx, ry, children \\ []) do
    element(
      "rect",
      %{
        x: l(x),
        y: l(y),
        width: l(width),
        height: l(height),
        rx: l(rx),
        ry: l(ry)
      },
      children
    )
  end

  def circle(cx, cy, r, children \\ []) do
    element("circle", %{cx: l(cx), cy: l(cy), r: l(r)}, children)
  end

  def ellipse(cx, cy, rx, ry, children \\ []) do
    element("ellipse", %{cx: l(cx), cy: l(cy), rx: l(rx), ry: l(ry)}, children)
  end

  def line(x1, y1, x2, y2, children \\ []) do
    element("line", %{x1: l(x1), y1: l(y1), x2: l(x2), y2: l(y2)}, children)
  end

  def polyline(points, children \\ []) do
    element("polyline", %{points: points_to_string(points, "")}, children)
  end

  def polygon(points, children \\ []) do
    element("polygon", %{points: points_to_string(points, "")}, children)
  end

  defp points_to_string([{x, y}], acc) do
    String.trim("#{acc} #{l(x)}, #{l(y)}")
  end

  defp points_to_string([{x, y} | points], acc) do
    points_to_string(points, "#{acc} #{l(x)}, #{l(y)},")
  end
end
