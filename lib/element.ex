defmodule SvgBuilder.Element do
  @moduledoc """
  Create and manipulate basic SVG elements.

  Elements are represented the same as XmlBuilder elements as a
  tuple with three values, the tag name, atttributes and child elements.

  ## Example

      iex> Element.element(:text, %{}, "A text element")
      {:text, %{}, "A text element"}

  """

  @type t() :: {atom, map, [__MODULE__.t() | binary]}

  @doc """
    Create an element.

    Returns: element

    ## Example

      iex> Element.element(:text, %{}, ["A text element"])
      {:text, %{}, [{nil, nil, "A text element"}]}

  """
  @spec element(atom, map, [t | binary]) :: t
  def element(name, attributes, children) do
    XmlBuilder.element(name, attributes, children)
  end

  @doc """
    Creates a group of elements,

    Returns: a group element

    ## Example

      iex> Element.group([Shape.rect(1,1,1,1), Shape.rect(2,2,1,1)])
      {:g, %{},
      [
        {:rect, %{height: "1", width: "1", x: "1", y: "1"}, []},
        {:rect, %{height: "1", width: "1", x: "2", y: "2"}, []}
        ]}

  """
  @spec group([t]) :: t
  def group(elements \\ []) do
    element(:g, %{}, elements)
  end

  @doc """
    Adds an attribute to an element.

    If the value is nil, then no attribute will be added.

    ## Example

      iex> Shape.rect(1,1,2,2) |> Element.add_attribute(:id, "test")
      {:rect, %{height: "2", id: "test", width: "2", x: "1", y: "1"}, []}

  """
  @spec add_attribute(t, atom, any) :: t
  def add_attribute(element, _, nil) do
    element
  end

  def add_attribute({type, attrs, children}, name, value) do
    {type, Map.put(attrs, name, value), children}
  end

  @doc """
    Add multiple attributes to an element.

    The attributes must be a map.


  """
  @spec add_attributes(t, map) :: t
  def add_attributes({type, attrs, children}, attributes) do
    {type, Map.merge(attrs, attributes), children}
  end

  @doc """
    Remove an attribute from an element.

    ## Example
      iex> {:rect, %{foo: 123, bar: 1234}, []} |> Element.remove_attribute(:foo)
      {:rect, %{bar: 1234}, []}
  """
  @spec remove_attribute(t, atom) :: t
  def remove_attribute({type, attrs, children}, name) do
    {type, Map.delete(attrs, name), children}
  end

  @doc """
    Sets the `id` attribute on an element.
  """
  @spec id(t, binary) :: t
  def id(element, id) do
    add_attribute(element, :id, id)
  end

  @doc """
    Sets the `xml:base` attribute on an element.
  """
  @spec xml_base(t, binary) :: t
  def xml_base(element, xml_base) do
    add_attribute(element, :"xml:base", xml_base)
  end

  @doc """
    Sets the `class` attribute on an element.

    The class can refer to any CSS class used by the SVG.
  """
  @spec class(t, binary) :: t
  def class(element, class) do
    add_attribute(element, :class, class)
  end

  @doc """
    Sets the `style` attribute on an element.

    The style value is a CSS type style string.
  """
  @spec style(t, binary) :: t
  def style(element, style) do
    add_attribute(element, :style, style)
  end

  @doc """
    Add a child to the element.

    Children are prepended to the list of children.
  """
  @spec add_child(t, t) :: t
  def add_child({type, attrs, children}, child_element) do
    {type, attrs, [child_element | children]}
  end
end
