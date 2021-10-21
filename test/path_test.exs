defmodule PathTest do
  use ExUnit.Case
  use SvgBuilder

  test "empty path" do
    assert {:path, %{d: ""}, []} == Path.path()
  end

  test :path do
    assert {:path, %{d: "M 10 10 L 20 20"}, []} = Path.path("M 10 10 L 20 20")
  end

  test "move" do
    p =
      Path.path()
      |> Path.move(10, 10)

    assert {:path, %{d: "M10 10"}, []} = p
  end

  test "move rel" do
    p =
      Path.path()
      |> Path.move_rel(1.23, 4.5)

    assert {:path, %{d: "m1.23 4.5"}, []} = p
  end

  test "line_to" do
    p =
      Path.path()
      |> Path.line_to(10, 10)

    assert {:path, %{d: "L10 10"}, []} = p
  end

  test "line_to with a list of x y pairs" do
    p =
      Path.path()
      |> Path.line_to([{1, 1}, {3.3, 4}, {5, 6}])

    assert {:path, %{d: "L1 1 3.3 4 5 6"}, []} = p
  end

  test "line_to_rel" do
    p =
      Path.path()
      |> Path.line_to_rel(1.23, 4.5)

    assert {:path, %{d: "l1.23 4.5"}, []} = p
  end

  test "horizontal line" do
    p =
      Path.path()
      |> Path.horizontal(20.3)

    assert {:path, %{d: "H20.3"}, []} = p
  end

  test "relative horizontal line" do
    p =
      Path.path()
      |> Path.horizontal_rel(20.3)

    assert {:path, %{d: "h20.3"}, []} = p
  end

  test "vertical line" do
    p =
      Path.path()
      |> Path.vertical(10)

    assert {:path, %{d: "V10"}, []} = p
  end

  test "relative vertical line" do
    p =
      Path.path()
      |> Path.vertical_rel(20)

    assert {:path, %{d: "v20"}, []} = p
  end

  test "close_path" do
    p =
      Path.path()
      |> Path.line_to_rel(1.23, 4.5)
      |> Path.close_path()

    assert {:path, %{d: "l1.23 4.5Z"}, []} = p
  end

  test "cubic" do
    p =
      Path.path()
      |> Path.cubic([{1, 1}, {3, 4}, {5, 6}])

    assert {:path, %{d: "C1 1 3 4 5 6"}, []} = p
  end

  test "relative cubic" do
    p =
      Path.path()
      |> Path.cubic_rel([{1, 1}, {3, 4}, {5, 6}])

    assert {:path, %{d: "c1 1 3 4 5 6"}, []} = p
  end

  test "smooth cubic" do
    p =
      Path.path()
      |> Path.smooth_cubic([{1, 1}, {3, 4}])

    assert {:path, %{d: "S1 1 3 4"}, []} = p
  end

  test "relative smooth cubic" do
    p =
      Path.path()
      |> Path.smooth_cubic_rel([{1, 1}, {3, 4}])

    assert {:path, %{d: "s1 1 3 4"}, []} = p
  end

  test "quadratic" do
    p =
      Path.path()
      |> Path.quadratic([{1, 1}, {3, 4}, {5, 6}])

    assert {:path, %{d: "Q1 1 3 4 5 6"}, []} = p
  end

  test "relative quadratic" do
    p =
      Path.path()
      |> Path.quadratic_rel([{1, 1}, {3, 4}, {5, 6}])

    assert {:path, %{d: "q1 1 3 4 5 6"}, []} = p
  end

  test "smooth quadratic" do
    p =
      Path.path()
      |> Path.smooth_quadratic([{1, 1}, {3, 4}])

    assert {:path, %{d: "T1 1 3 4"}, []} = p
  end

  test "relative smooth quadratic" do
    p =
      Path.path()
      |> Path.smooth_quadratic_rel([{1, 1}, {3, 4}])

    assert {:path, %{d: "t1 1 3 4"}, []} = p
  end

  test "arc" do
    p =
      Path.path()
      |> Path.arc(25, 25, -30, false, true, 50, -25)

    assert {:path, %{d: "A25 25 -30 0 1 50 -25"}, []} = p
  end

  test "relative arc" do
    p =
      Path.path()
      |> Path.arc_rel(25, 25, -30, false, true, 50, -25)

    assert {:path, %{d: "a25 25 -30 0 1 50 -25"}, []} = p
  end

  test "several path elements" do
    p =
      Path.path()
      |> Path.move(3, 4)
      |> Path.line_to(10, 10)
      |> Path.horizontal(34.5)

    assert {:path, %{d: "M3 4L10 10H34.5"}, []} = p
  end

  test "a very long path has carriage returns inserted" do
  end
end
