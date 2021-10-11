defmodule SvgBuilder.MixProject do
  use Mix.Project

  def project do
    [
      app: :svg_builder,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:xml_builder, "~> 2.1"},
      {:tesla, "~> 1.4.3", only: :test},
      {:jason, ">= 1.0.0", only: :test}
    ]
  end
end
