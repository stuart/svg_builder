defmodule SvgBuilder.MixProject do
  use Mix.Project

  def project do
    [
      app: :svg_builder,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "SVGBuilder",
      source_url: "https://github.com/stuart/svg_builder",
      docs: [],
      dialyzer: [
        plt_add_deps: :xml_builder,
        plt_add_apps: [],
        plt_ignore_apps: []
      ]
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
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:tesla, "~> 1.4.3", only: :test, runtime: false},
      {:jason, ">= 1.0.0", only: [:dev, :test], runtime: false}
    ]
  end
end
