defmodule SvgBuilder.Transform do
  def transform({type, attrs, children}, transforms) when is_list(transforms) do
    t =
      [Map.get(attrs, :transform, "") | transforms]
      |> Enum.join(" ")
      |> String.trim()

    {type, Map.put(attrs, :transform, t), children}
  end

  def matrix(a, b, c, d, e, f) do
    "matrix(#{a},#{b},#{c},#{d},#{e},#{f})"
  end

  def translate(tx, ty) do
    "translate(#{tx},#{ty})"
  end

  def scale(sx, sy) do
    "scale(#{sx},#{sy})"
  end

  def rotate(angle) do
    "rotate(#{angle})"
  end

  def rotate(angle, cx, cy) do
    "rotate(#{angle}, #{cx}, #{cy})"
  end

  def skew_x(angle) do
    "skewX(#{angle})"
  end

  def skew_y(angle) do
    "skewY(#{angle})"
  end
end
