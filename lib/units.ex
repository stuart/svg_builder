defmodule SvgBuilder.Units do
  @moduledoc """
  Units for SVG documents.
  """

  @type len_t() :: number | {number, atom} | {number, number} | binary | nil
  @type length_list_t() :: len_t | [len_t]
  @type angle_t() :: number | binary | {number, :deg | :rad | :grad}

  @spec angle(angle_t) :: binary
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

  @spec len(len_t) :: binary | nil
  def len(nil) do
    nil
  end

  def len(length) when is_number(length) do
    "#{length}"
  end

  def len(length) when is_binary(length) do
    regexp = ~r/(([\+\-]?[0-9]*\.[0-9+])|([\+\-]?[0-9]+))(em|ex|px|in|cm|mm|pt|pc|%)?/

    if String.match?(length, regexp) do
      length
    else
      raise ArgumentError, "invalid length for SvgBuilder attribute/property"
    end
  end

  def len({length, unit}) when unit in [:em, :ex, :px, :in, :cm, :mm, :pt, :pc] do
    "#{length}#{unit}"
  end

  def len({x, y}) when is_number(y) do
    "#{x} #{y}"
  end

  @spec length_list(length_list_t) :: binary | nil
  def length_list(l) when is_list(l) do
    do_length_list(l, "")
  end

  def length_list(l) do
    len(l)
  end

  defp do_length_list([n], acc) do
    String.trim("#{acc} #{len(n)}")
  end

  defp do_length_list([n | rest], acc) do
    do_length_list(rest, "#{acc} #{len(n)}")
  end

  @spec number(number | binary) :: binary
  def number(n) when is_number(n) do
    "#{n}"
  end

  def number(n) when is_binary(n) do
    regexp = ~r/([\+\-]?[0-9]*\.[0-9+])|([\+\-]?[0-9]+)/

    if String.match?(n, regexp) do
      n
    else
      raise ArgumentError, "invalid number for SvgBuilder attribute/property"
    end
  end

  @spec number_list(number | binary | [number | binary]) :: binary
  def number_list(n) when is_number(n) do
    number(n)
  end

  def number_list(n) when is_list(n) do
    do_number_list(n, "")
  end

  defp do_number_list([n], acc) do
    String.trim("#{acc} #{number(n)}")
  end

  defp do_number_list([n | rest], acc) do
    do_number_list(rest, "#{acc} #{number(n)}")
  end
end
