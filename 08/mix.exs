defmodule Day8.MixProject do
  use Mix.Project

  def project do
    [
      app: :day8,
      version: "0.1.0",
      elixir: "~> 1.14",
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

  defp deps do
    [
      {:comb, git: "https://github.com/tallakt/comb.git", branch: "master"}
    ]
  end
end
