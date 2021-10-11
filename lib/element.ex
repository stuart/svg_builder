defmodule SvgBuilder.Element do
  import XmlBuilder
  # Add children
  def add_child({type, attrs, children}, child) do
    {type, attrs, [child | children]}
  end

  def add_chlidren({type, attrs, children}, children) when is_list(children) do
    {type, attrs, children ++ children}
  end

  # Containers
  def group(elements \\ []) do
    element("g", elements)
  end

  # Attributes
  def add_attribute({type, attrs, children}, name, value) do
    {type, Map.put(attrs, name, value), children}
  end

  def add_attributes({type, attrs, children}, attributes) do
    {type, Map.merge(attrs, attributes), children}
  end

  def id(element, id) do
    add_attribute(element, :id, id)
  end

  def xml_base(element, xml_base) do
    add_attribute(element, :"xml:base", xml_base)
  end

  def class(element, class) do
    add_attribute(element, :class, class)
  end
end
