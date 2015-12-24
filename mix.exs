defmodule Heapq.Mixfile do
  use Mix.Project

  def project do
    [app: :heapq,
     version: "0.0.1",
     elixir: ">= 1.0.0",
     description: "A Heap-based Priority Queue Implementation in Elixir.",
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:excheck, "~> 0.3", only: :test},
      {:triq, github: "krestenkrab/triq", only: :test}
    ]
  end

  defp package do
    [files: ["lib", "mix.exs", "README*"],
     contributors: ["Kohei Takeda"],
     licenses: ["BSD"],
     links: %{"GitHub" => "https://github.com/takscape/elixir-heapq"}]
  end
end
