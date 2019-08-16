defmodule ExHttpLink.MixProject do
  use Mix.Project

  def project do
    if Mix.env() == :dial, do: Application.ensure_all_started(:ex_unit)

    [
      app: :ex_http_link,
      name: "ex_http_link",
      description: "An Elixir library for the HTTP Link header as specified in RFC 5988 Web Linking",
      source_url: "https://github.com/myfreeweb/ex_http_link",
      version: "0.1.2",
      elixir: "~> 1.7",
      deps: deps(),
      package: package(),
      preferred_cli_env: [dialyzer: :dial]
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:nimble_parsec, "~> 0.5"},
      {:ex_doc, "~> 0.20.2", only: [:dev, :test, :docs]}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "CODE_OF_CONDUCT.md", "UNLICENSE"],
      maintainers: ["Greg V"],
      licenses: ["Unlicense"],
      links: %{"GitHub" => "https://github.com/myfreeweb/ex_http_link"}
    ]
  end
end
