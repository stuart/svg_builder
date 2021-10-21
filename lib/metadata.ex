defmodule SvgBuilder.Metadata do
  import XmlBuilder

  @moduledoc """
  Create various metadata tags.

  https://www.w3.org/TR/SVG11/metadata.html
  """

  @doc """
  Add a description element.
  """
  @spec desc(SvgBuilder.Element.t(), binary) :: SvgBuilder.Element.t()
  def desc({type, attrs, children}, description) do
    {type, attrs, [element(:desc, description) | children]}
  end

  @doc """
  Add a metadata element.
  """
  @spec metadata(SvgBuilder.Element.t(), binary) :: SvgBuilder.Element.t()
  def metadata({type, attrs, children}, data) do
    {type, attrs, [element(:metadata, data) | children]}
  end

  @doc """
  Add a title element.
  """
  @spec title(SvgBuilder.Element.t(), binary) :: SvgBuilder.Element.t()
  def title({type, attrs, children}, title) do
    {type, attrs, [element(:title, title) | children]}
  end
end
