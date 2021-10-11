defmodule SvgBuilder.Units do
  @number_regex ~r/(([\+\-]?[0-9]*\.[0-9+])|([\+\-]?[0-9]+))/

  defmacro l(length) do
    quote do
      SvgBuilder.Units.length(unquote(length))
    end
  end

  def angle(angle) when is_number(angle) do
    "#{angle}"
  end

  def angle(angle) when is_binary(angle) do
    regexp = ~r/(([\+\-]?[0-9]*\.[0-9+])|([\+\-]?[0-9]+))(deg|grad|rad)?/

    if String.match?(angle, regexp) do
      angle
    else
      raise ArgumentError, "invalid angle for SvgBuilder attribute/property"
    end
  end

  def angle({angle, unit}) when unit in [:deg, :rad, :grad] do
    "#{angle}#{unit}"
  end

  def length(length) when is_number(length) do
    "#{length}"
  end

  def length(length) when is_binary(length) do
    regexp = ~r/(([\+\-]?[0-9]*\.[0-9+])|([\+\-]?[0-9]+))(em|ex|px|in|cm|mm|pt|pc|%)?/

    if String.match?(length, regexp) do
      length
    else
      raise ArgumentError, "invalid length for SvgBuilder attribute/property"
    end
  end

  def length({length, unit}) when unit in [:em, :ex, :px, :in, :cm, :mm, :pt, :pc] do
    "#{length}#{unit}"
  end

  def number(n) when is_number(n) do
    "#{n}"
  end

  def number(n) when is_binary(n) do
    regexp = ~r/([\+\-]?[0-9]*\.[0-9+])|([\+\-]?[0-9]+)/

    if String.match?(n, regexp) do
      n
    else
      raise ArgumentError, "invalid length for SvgBuilder attribute/property"
    end
  end
end
