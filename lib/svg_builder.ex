defmodule SvgBuilder do
  import XmlBuilder

  alias SvgBuilder.{Element, Units}

  @moduledoc """
  Create SVG documents.


  """

  defmacro __using__(_options) do
    quote do
      alias SvgBuilder.Shape
      alias SvgBuilder.Transform
      alias SvgBuilder.Path
      alias SvgBuilder.Painting
      alias SvgBuilder.Metadata
      alias SvgBuilder.Element
      alias SvgBuilder.Text
      alias SvgBuilder.Font
    end
  end

  @spec write(IO.device(), iodata()) :: :ok | {:error, term()}
  def write(file, svg) do
    IO.binwrite(file, generate(svg))
  end

  @spec document(Units.len_t(), Units.len_t(), [SvgBuilder.Element.t()]) ::
          nonempty_maybe_improper_list()
  def document(width, height, elements \\ []) do
    document([
      doctype("svg",
        public: ["-//W3C//DTD SVG 1.1//EN", "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"]
      ),
      svg(width, height, elements)
    ])
  end

  @spec svg(Units.len_t, Units.len_t) :: Element.t
  def svg(width, height, elements \\ []) do
    Element.element(:svg, %{
      version: "1.1",
      width: Units.len(width),
      height: Units.len(height),
      viewBox: "0 0 #{Units.len(width)} #{Units.len(height)}",
      xmlns: "http://www.w3.org/2000/svg",
      "xmlns:xlink": "http://www.w3.org/1999/xlink"
    }, elements)
  end
end
