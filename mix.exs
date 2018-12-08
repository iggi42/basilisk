defmodule Basilisk.MixProject do
  use Mix.Project

  @version "0.1.0"
  @repo "https://github.com/skwerlman/basilisk"

  def project do
    [
      app: :basilisk,
      version: @version,
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, test: :test],
      aliases: aliases(),
      deps: deps(),
      docs: docs(),
      dialyzer: dialyzer(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Basilisk.Application, []},
      start_phases: [
        init: [],
        ready: []
      ]
    ]
  end

  defp aliases do
    [
      setup: [
        "cmd ./mix_tasks/setup_hooks.sh",
        "deps.get",
        "compile",
        "ecto.create",
        "ecto.migrate"
      ],
      hipe: ["protoc", "cmd ./tasks/hipe.sh"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:argon2_elixir, "~> 1.3"},
      {:comeonin, "~> 4.1"},
      {:ecto_sql, "~> 3.0"},
      {:ecto, "~> 3.0"},
      {:exprotobuf, "~> 1.2"},
      {:flex_logger, "~> 0.2"},
      {:logger_file_backend, "~> 0.0"},
      {:postgrex, ">= 0.0.0"},
      {:ranch, "~> 1.7"},
      #####
      {:credo, "~> 1.0", runtime: false, only: [:dev, :test]},
      {:dialyxir, ">= 1.0.0-rc.4", runtime: false, only: [:dev, :test]},
      {:distillery, "~> 2.0", runtime: false},
      {:ex_doc, "~> 0.19", runtime: false, only: :dev},
      {:excoveralls, "~> 0.10", runtime: false, only: :test}
    ]
  end

  defp docs do
    [
      main: "readme",
      # source_ref: "v#{@version}",
      source_url: @repo,
      extras: [
        "README.md": [title: "README"]
      ]
    ]
  end

  defp dialyzer do
    plt =
      case Mix.env() do
        # this fixes a failure when dialyxir is run in a test env
        :test ->
          [:ex_unit]

        _ ->
          []
      end

    [
      plt_add_apps: plt,
      flags: [
        :unmatched_returns,
        :error_handling,
        :race_conditions,
        :no_opaque,
        :underspecs
      ]
    ]
  end

  defp package do
    [
      maintainers: ["skwerlman"],
      licenses: ["GPLv3"],
      files: files(),
      links: links()
    ]
  end

  defp files do
    [
      "lib",
      "mix.exs",
      "LICENSE",
      "README.md"
    ]
  end

  defp links do
    %{
      "Github" => @repo,
      "Cockatrice Wiki" => "https://github.com/cockatrice/cockatrice/wiki"
    }
  end
end
