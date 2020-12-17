defmodule WebService.MixProject do
  use Mix.Project

  def project do
    [
      app: :webservice,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: false,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [],
      mod: {WebService.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.7"},
      {:poison, "~> 4.0"},
      {:csv, "~> 2.4"},
    ]
  end
end
