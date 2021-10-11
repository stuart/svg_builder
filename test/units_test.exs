defmodule SvgBuilder.UnitsTest do
  use ExUnit.Case

  test "length with a number" do
    assert "10" = SvgBuilder.Units.length(10)
  end

  test "length with a string" do
    assert "10" = SvgBuilder.Units.length("10")
  end

  test "length with a unit string" do
    assert "10px" = SvgBuilder.Units.length("10px")
  end

  test "length with a number and unit" do
    assert "10em" = SvgBuilder.Units.length({10, :em})
  end
end
