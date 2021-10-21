defmodule SvgBuilder.UnitsTest do
  use ExUnit.Case

  alias SvgBuilder.Units

  test "angle with units" do
    assert "10grad" = Units.angle({10, :grad})
  end

  test "length with a number" do
    assert "10" = Units.len(10)
  end

  test "length with a string" do
    assert "10" = Units.len("10")
  end

  test "length with a unit string" do
    assert "10px" = Units.len("10px")
  end

  test "length with a number and unit" do
    assert "10em" = Units.len({10, :em})
  end

  test "number" do
    assert "-10.0" = Units.number(-10.0)
  end

  test "list of numbers" do
    assert "10 20 34.5" = Units.number_list([10, 20, 34.5])
  end

  test "list of numbers with one member" do
    assert "10.4" = Units.number_list(10.4)
  end

  test "list of lengths" do
    assert "10px 34 11em" = Units.length_list(["10px", 34, {11, :em}])
  end
end
