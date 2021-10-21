defmodule SvgBuilder.Path do
  import XmlBuilder
  alias SvgBuilder.{Element}

  @moduledoc """
  Create and modify path elements.
  """

  @spec path() :: Element.t()
  def path() do
    element("path", %{d: ""}, [])
  end

  @spec path(Element.t() | [Element.t()]) :: Element.t()
  def path(children) when is_list(children) do
    element("path", %{d: ""}, children)
  end

  @spec path(binary, [Element.t()]) :: Element.t()
  def path(d, children \\ []) when is_binary(d) do
    element("path", %{d: d}, children)
  end

  @spec move(Element.t(), number, number) :: Element.t()
  def move(path, x, y) do
    add_to_path(path, "M#{x} #{y}")
  end

  @spec move_rel(Element.t(), number, number) :: Element.t()
  def move_rel(path, x, y) do
    add_to_path(path, "m#{x} #{y}")
  end

  @spec line_to(Element.t(), {number, number} | [{number, number}]) :: Element.t()
  def line_to(path, points) do
    add_to_path(path, "L#{points_list(points)}")
  end

  @spec line_to(Element.t(), number, number) :: Element.t()
  def line_to(path, x, y) do
    add_to_path(path, "L#{x} #{y}")
  end

  @spec line_to_rel(Element.t(), number, number) :: Element.t()
  def line_to_rel(path, x, y) do
    add_to_path(path, "l#{x} #{y}")
  end

  @spec horizontal(Element.t(), number) :: Element.t()
  def horizontal(path, x) do
    add_to_path(path, "H#{x}")
  end

  @spec horizontal_rel(Element.t(), number) :: Element.t()
  def horizontal_rel(path, x) do
    add_to_path(path, "h#{x}")
  end

  @spec vertical(Element.t(), number) :: Element.t()
  def vertical(path, y) do
    add_to_path(path, "V#{y}")
  end

  @spec vertical_rel(Element.t(), number) :: Element.t()
  def vertical_rel(path, y) do
    add_to_path(path, "v#{y}")
  end

  @spec cubic(Element.t(), [{number, number}]) :: Element.t()
  def cubic(path, points) do
    add_to_path(path, "C#{points_list(points)}")
  end

  @spec cubic_rel(Element.t(), [{number, number}]) :: Element.t()
  def cubic_rel(path, points) do
    add_to_path(path, "c#{points_list(points)}")
  end

  @spec smooth_cubic(Element.t(), [{number, number}]) :: Element.t()
  def smooth_cubic(path, points) do
    add_to_path(path, "S#{points_list(points)}")
  end

  @spec smooth_cubic_rel(Element.t(), [{number, number}]) :: Element.t()
  def smooth_cubic_rel(path, points) do
    add_to_path(path, "s#{points_list(points)}")
  end

  @spec quadratic(Element.t(), [{number, number}]) :: Element.t()
  def quadratic(path, points) do
    add_to_path(path, "Q#{points_list(points)}")
  end

  @spec quadratic_rel(Element.t(), [{number, number}]) :: Element.t()
  def quadratic_rel(path, points) do
    add_to_path(path, "q#{points_list(points)}")
  end

  @spec smooth_quadratic(Element.t(), [{number, number}]) :: Element.t()
  def smooth_quadratic(path, points) do
    add_to_path(path, "T#{points_list(points)}")
  end

  @spec smooth_quadratic_rel(Element.t(), [{number, number}]) :: Element.t()
  def smooth_quadratic_rel(path, points) do
    add_to_path(path, "t#{points_list(points)}")
  end

  @spec arc(Element.t(), number, number, number, boolean, boolean, number, number) :: Element.t()
  def arc(path, rx, ry, x_rot, large_arg_flag, sweep_flag, x, y) do
    add_to_path(
      path,
      "A#{rx} #{ry} #{x_rot} #{to_flag(large_arg_flag)} #{to_flag(sweep_flag)} #{x} #{y}"
    )
  end

  @spec arc_rel(Element.t(), number, number, number, boolean, boolean, number, number) ::
          Element.t()
  def arc_rel(path, rx, ry, x_rot, large_arg_flag, sweep_flag, x, y) do
    add_to_path(
      path,
      "a#{rx} #{ry} #{x_rot} #{to_flag(large_arg_flag)} #{to_flag(sweep_flag)} #{x} #{y}"
    )
  end

  @spec close_path(Element.t()) :: Element.t()
  def close_path(path) do
    add_to_path(path, "Z")
  end

  @spec add_to_path(Element.t(), binary) :: Element.t()
  defp add_to_path({"path", %{d: d} = attrs, children}, string) do
    {"path", Map.put(attrs, :d, String.trim("#{d}#{string}")), children}
  end

  @spec points_list([{number, number}]) :: binary
  defp points_list(points_list) do
    points_list
    |> Enum.map(fn {x, y} -> "#{x} #{y}" end)
    |> Enum.join(" ")
  end

  defp to_flag(true) do
    1
  end

  defp to_flag(false) do
    0
  end
end
