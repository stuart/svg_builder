defmodule SvgBuilder.Path do
  import XmlBuilder

  def path() do
    element("path", %{d: ""}, [])
  end

  def path(children) when is_list(children) do
    element("path", %{d: ""}, children)
  end

  def path(d, children \\ []) when is_binary(d) do
    element("path", %{d: d}, children)
  end

  def move(path, x, y) do
    add_to_path(path, "M #{x} #{y}")
  end

  def move_rel(path, x, y) do
    add_to_path(path, "m #{x} #{y}")
  end

  def line_to(path, points) do
    add_to_path(path, "L #{points_to_string(points)}")
  end

  def line_to(path, x, y) do
    add_to_path(path, "L #{x} #{y}")
  end

  def line_to_rel(path, x, y) do
    add_to_path(path, "l #{x} #{y}")
  end

  def horizontal(path, x) do
    add_to_path(path, "H #{x}")
  end

  def horizontal_rel(path, x) do
    add_to_path(path, "h #{x}")
  end

  def vertical(path, y) do
    add_to_path(path, "V #{y}")
  end

  def vertical_rel(path, y) do
    add_to_path(path, "v #{y}")
  end

  def cubic(path, points) do
    add_to_path(path, "C #{points_to_string(points)}")
  end

  def cubic_rel(path, points) do
    add_to_path(path, "c #{points_to_string(points)}")
  end

  def smooth_cubic(path, points) do
    add_to_path(path, "S #{points_to_string(points)}")
  end

  def smooth_cubic_rel(path, points) do
    add_to_path(path, "s #{points_to_string(points)}")
  end

  def quadratic(path, points) do
    add_to_path(path, "Q #{points_to_string(points)}")
  end

  def quadratic_rel(path, points) do
    add_to_path(path, "q #{points_to_string(points)}")
  end

  def smooth_quadratic(path, points) do
    add_to_path(path, "T #{points_to_string(points)}")
  end

  def smooth_quadratic_rel(path, points) do
    add_to_path(path, "t #{points_to_string(points)}")
  end

  def arc(path, rx, ry, x_rot, large_arg_flag, sweep_flag, x, y)
      when large_arg_flag in [0, 1] and sweep_flag in [0, 1] do
    add_to_path(path, "A #{rx} #{ry} #{x_rot} #{large_arg_flag} #{sweep_flag} #{x} #{y}")
  end

  def arc_rel(path, rx, ry, x_rot, large_arg_flag, sweep_flag, x, y)
      when large_arg_flag in [0, 1] and sweep_flag in [0, 1] do
    add_to_path(path, "a #{rx} #{ry} #{x_rot} #{large_arg_flag} #{sweep_flag} #{x} #{y}")
  end

  def close_path(path) do
    add_to_path(path, "Z")
  end

  defp add_to_path({"path", %{d: d} = attrs, children}, string) do
    {"path", Map.put(attrs, :d, String.trim("#{d} #{string}")), children}
  end

  defp points_to_string(points) do
    do_points_to_string(points, "")
  end

  defp do_points_to_string([{x, y}], acc) do
    String.trim("#{acc} #{x} #{y}")
  end

  defp do_points_to_string([{x, y} | points], acc) do
    do_points_to_string(points, "#{acc} #{x} #{y}")
  end
end
