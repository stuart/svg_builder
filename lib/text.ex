defmodule SvgBuilder.Text do
  import XmlBuilder
  alias SvgBuilder.{Element, Units}

  @type text_t :: binary | Element.t() | [Element.t()]

  @moduledoc """
  Add and modify text elements.
  """

  @doc """
  Create a text element.

  The `text` may be a binary, text element or list of text elements.
  """
  @spec text(text_t) :: Element.t()
  def text(text) do
    element(:text, %{}, text_content(text))
  end

  @doc """
  Create a text element with glyph positions.

  x : An x coordintate or a list of x coordinates to be assigned to the
  glyphs of the content.

  y : An y coordintate or a list of y coordinates to be assigned to the
  glyphs of the content.

  text : Content of the text element.
  """
  @spec text(Units.length_list_t(), Units.length_list_t(), text_t) :: Element.t()
  def text(x, y, text) do
    element(
      :text,
      %{x: "#{Units.length_list(x)}", y: "#{Units.length_list(y)}"},
      text_content(text)
    )
  end

  @spec text(
          Units.length_list_t(),
          Units.length_list_t(),
          Units.length_list_t(),
          Units.length_list_t(),
          text_t
        ) :: Element.t()
  def text(x, y, dx, dy, text) do
    element(
      :text,
      %{
        x: "#{Units.length_list(x)}",
        y: "#{Units.length_list(y)}",
        dx: "#{Units.length_list(dx)}",
        dy: "#{Units.length_list(dy)}"
      },
      text_content(text)
    )
  end

  @spec tspan(text_t) :: Element.t()
  def tspan(text) do
    element(:tspan, %{}, tspan_content(text))
  end

  @spec tspan(Units.length_list_t(), Units.length_list_t(), text_t) :: Element.t()
  def tspan(x, y, text) do
    element(
      :tspan,
      %{x: "#{Units.length_list(x)}", y: "#{Units.length_list(y)}"},
      text_content(text)
    )
  end

  @spec tspan(
          Units.length_list_t(),
          Units.length_list_t(),
          Units.length_list_t(),
          Units.length_list_t(),
          text_t
        ) :: Element.t()
  def tspan(x, y, dx, dy, text) do
    element(
      :tspan,
      %{
        x: "#{Units.length_list(x)}",
        y: "#{Units.length_list(y)}",
        dx: "#{Units.length_list(dx)}",
        dy: "#{Units.length_list(dy)}"
      },
      text_content(text)
    )
  end

  @doc """
  Rotate the glyphs in a text element.

  If the argument is a single number then all text is rotated.
  A list rotates each glyph by the amount corresponding to the glyph in the list.

  """
  @spec rotate(Element.t(), Units.length_list_t()) :: Element.t()
  def rotate({type, _, _} = element, rotation) when type in [:text, :tspan] do
    Element.add_attribute(element, :rotate, Units.length_list(rotation))
  end

  defp text_content(text) when is_list(text) do
    Enum.filter(text, &is_valid_text_content/1)
  end

  defp text_content(text) when is_binary(text) do
    text
  end

  defp is_valid_text_content(t) when is_binary(t) do
    true
  end

  defp is_valid_text_content({type, _, _})
       when type in [:altGlyph, :textPath, :tref, :tspan, :metadata, :desc, :title, :a] do
    true
  end

  defp is_valid_text_content(_) do
    false
  end

  defp tspan_content(text) when is_list(text) do
    Enum.filter(text, &is_valid_tspan_content/1)
  end

  defp tspan_content(text) when is_binary(text) do
    text
  end

  defp is_valid_tspan_content(t) when is_binary(t) do
    true
  end

  defp is_valid_tspan_content({type, _, _})
       when type in ["altGlyph", "tref", :tspan, "metadata", "desc", "title", "a"] do
    true
  end

  defp is_valid_tspan_content(_) do
    false
  end
end
