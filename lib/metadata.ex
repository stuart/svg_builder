defmodule SvgBuilder.Metadata do
  import XmlBuilder

  def desc({type, attrs, children}, description) do
    {type, attrs, [element("desc", description) | children]}
  end

  def metadata({type, attrs, children}, data) do
    {type, attrs, [element("metadata", data) | children]}
  end
end
