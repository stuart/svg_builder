defmodule SvgBuilder.TransformTest do
  use ExUnit.Case
  use SvgBuilder

  test "translate" do
    r =
      {"shape", %{}, []}
      |> Transform.translate(10, 10)

    assert {_, %{transform: "translate(10,10)"}, _} = r
  end

  test "matrix" do
    r =
      {"shape", %{}, []}
      |> Transform.matrix({1, 2, 3, 4, 5, 6})

    assert {_, %{transform: "matrix(1,2,3,4,5,6)"}, []} = r
  end

  test "scale" do
    r =
      {"shape", %{}, []}
      |> Transform.scale(0.5, 0.6)

    assert {_, %{transform: "scale(0.5,0.6)"}, []} = r
  end

  test "rotate" do
    r =
      {"shape", %{}, []}
      |> Transform.rotate(27.5)

    assert {_, %{transform: "rotate(27.5)"}, []} = r
  end

  test "rotate with center" do
    r =
      {"shape", %{}, []}
      |> Transform.rotate(27.5, 10.0, 4.0)

    assert {_, %{transform: "rotate(27.5, 10.0, 4.0)"}, []} = r
  end

  test "skew_x" do
    r =
      {"shape", %{}, []}
      |> Transform.skew_x(4)

    assert {_, %{transform: "skewX(4)"}, []} = r
  end

  test "skew_y" do
    r =
      {"shape", %{}, []}
      |> Transform.skew_y(120.0)

    assert {_, %{transform: "skewY(120.0)"}, []} = r
  end

  test "chained transforms" do
    r =
      {"shape", %{}, []}
      |> Transform.skew_x(10)
      |> Transform.rotate(10)
      |> Transform.scale(1.0, 2.0)

    assert {_, %{transform: "skewX(10) rotate(10) scale(1.0,2.0)"}, []} = r
  end
end
