defmodule SvgBuilder.TransformTest do
  use ExUnit.Case
  use SvgBuilder

  test "matrix" do
    r = apply_transforms([Transform.matrix(1, 2, 3, 4, 5, 6)])

    assert {"rect", %{transform: "matrix(1,2,3,4,5,6)"}, []} = r
  end

  test "scale" do
    r = apply_transforms([Transform.scale(0.5, 0.6)])

    assert {"rect", %{transform: "scale(0.5,0.6)"}, []} = r
  end

  test "rotate" do
    r = apply_transforms([Transform.rotate(27.5)])

    assert {"rect", %{transform: "rotate(27.5)"}, []} = r
  end

  test "rotate with center" do
    r = apply_transforms([Transform.rotate(27.5, 10.0, 4.0)])

    assert {"rect", %{transform: "rotate(27.5, 10.0, 4.0)"}, []} = r
  end

  test "skew_x" do
    r = apply_transforms([Transform.skew_x(4)])

    assert {"rect", %{transform: "skewX(4)"}, []} = r
  end

  test "skew_y" do
    r = apply_transforms([Transform.skew_y(120.0)])

    assert {"rect", %{transform: "skewY(120.0)"}, []} = r
  end

  test "chained transforms" do
    r = apply_transforms([Transform.skew_x(10), Transform.rotate(10), Transform.scale(1.0, 2.0)])

    assert {"rect", %{transform: "skewX(10) rotate(10) scale(1.0,2.0)"}, []} = r
  end

  def apply_transforms(transforms) do
    Shape.rect(10, 10, 100, 100)
    |> Transform.transform(transforms)
  end
end
