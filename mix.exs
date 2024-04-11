defmodule WebService.MixProject do
  use Mix.Project

  def project do
    [
      app: :webservice,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: false,
      deps: deps(),
      dialyzer: [plt_add_apps: [:mix]]
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
      {:httpoison, "~> 2.0"},
      {:poison, "~> 4.0"},
      {:csv, "~> 2.4"},
      {:dotenvy, "~> 0.8.0"},
      {:mock, "~> 0.3.0", only: :test},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
    ]
  end
end
