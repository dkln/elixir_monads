defmodule Monads.MixProject do
  @moduledoc false
  use Mix.Project

  def project do
    [
      app: :monads,
      version: "0.1.0",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      compilers: Mix.compilers(),
      deps: deps(),
      dialyzer: [plt_add_apps: [:mix]],
      aliases: aliases()
    ]
  end

  def application, do: []

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps, do: []

  defp aliases, do: []
end
