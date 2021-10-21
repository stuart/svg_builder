defmodule SvgBuilderTest do
  use ExUnit.Case
  use SvgBuilder

  doctest SvgBuilder

  test "creating an svg element" do
    assert {:svg,
            %{
              height: "200",
              version: "1.1",
              viewBox: "0 0 100 200",
              width: "100",
              xmlns: "http://www.w3.org/2000/svg",
              "xmlns:xlink": "http://www.w3.org/1999/xlink"
            }, []} == SvgBuilder.svg(100, 200)
  end

  test "creating a defs element" do
    assert {:defs, %{}, []} = SvgBuilder.defs()
  end

  test "creating a defs element with children" do
    assert {:defs, %{}, [{:circle, %{cx: "10", cy: "10", r: "4"}, []}]} =
             SvgBuilder.defs([SvgBuilder.Shape.circle(10, 10, 4)])
  end
end
