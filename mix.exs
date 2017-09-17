defmodule Khcpl.Mixfile do
  use Mix.Project

  def project do
    [
      app: :khcpl,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Khcpl.Application, []},
      extra_applications: [:logger, :runtime_tools, :exq, :absinthe, :absinthe_relay, :absinthe_ecto]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:sqlite_ecto2, "~> 2.0.0-dev.8"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:floki, "~> 0.18.0"},
      {:httpoison, "~> 0.13"},
      {:poison, "~> 2.0"},
      {:exq, "~> 0.9.0"},
      {:absinthe, "~> 1.3.2"},
      {:absinthe_plug, "~> 1.1"},
      {:absinthe_relay, "~> 1.3.5"},
      {:absinthe_ecto, git: "https://github.com/absinthe-graphql/absinthe_ecto.git"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
