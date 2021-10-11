defmodule SvgBuilder do
  import XmlBuilder
  import SvgBuilder.Units

  alias SvgBuilder.{Element, Painting}

  defmacro __using__(_options) do
    quote do
      alias SvgBuilder.Shape
      alias SvgBuilder.Transform
      alias SvgBuilder.Path
      alias SvgBuilder.Painting
      alias SvgBuilder.Metadata
      alias SvgBuilder.Element
    end
  end

  def write(file, svg) do
    IO.binwrite(file, generate(svg))
  end

  def svg(width, height, elements \\ []) do
    document([
      doctype("svg",
        public: ["-//W3C//DTD SVG 1.1//EN", "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"]
      ),
      element(
        :svg,
        %{
          version: "1.1",
          width: l(width),
          height: l(height),
          viewBox: "0 0 #{l(width)} #{l(height)}",
          xmlns: "http://www.w3.org/2000/svg",
          "xmlns:xlink": "http://www.w3.org/1999/xlink"
        },
        elements
      )
    ])
  end

  def style(element, style) do
    Element.add_attribute(element, :style, style)
  end
end
