defmodule Genx.MixProject do
  @moduledoc false

  use Mix.Project

  @doc """
  The main configuration or the project.

  Check `Mix.Project` for more details.
  """
  def project do
    [
      app: :genx,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      preferred_cli_env: ["ci.test": :test, "code.check": :test, main: :test],
      start_permanent: Mix.env() == :prod,
      test_coverage: [summary: [threshold: 80.69]],
      aliases: aliases(),
      dialyzer: dialyzer(),
      deps: deps()
    ]
  end

  @doc """
  Configuration for the OTP application.

  Type `mix help compile.app` for more information.
  """
  def application do
    [
      mod: {Genx.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp dialyzer do
    [
      plt_core_path: "plts",
      plt_file: {:no_warn, "plts/dialyzer.plt"}
    ]
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:credo, "~> 1.6",
       github: "kelvinst/credo", branch: "alias-as-ignore", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:doctor, "~> 0.19.0", only: [:dev, :test]},
      {:ecto_sql, "~> 3.6"},
      {:esbuild, "~> 0.4", runtime: Mix.env() == :dev},
      {:ex_doc, "~> 0.27", only: [:dev, :test], runtime: false},
      {:floki, ">= 0.30.0", only: :test},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:mix_audit, "~> 1.0", only: [:dev, :test], runtime: false},
      {:phoenix, "~> 1.6.11"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.17.5"},
      {:plug_cowboy, "~> 2.5"},
      {:postgrex, ">= 0.0.0"},
      {:sobelow, "~> 0.8", only: [:dev, :test]},
      {:swoosh, "~> 1.3"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, 
  # run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "assets.deploy": ["esbuild default --minify", "phx.digest"],
      "ci.compile": "compile --warnings-as-errors --force",
      "ci.db": "ecto.rollback --check",
      "ci.deps.prepare": ["deps.get", "deps.compile --ignore-warnings"],
      "ci.deps.run": ["hex.audit", "deps.unlock --check-unused", "deps.audit"],
      "ci.deps": ["ci.deps.prepare", "ci.deps.run"],
      "ci.docs": ["doctor", "docs --warnings-as-errors"],
      "ci.linters": ["format --check-formatted --dry-run", "credo", "sobelow --config"],
      "ci.test": "test --cover",
      "ci.typecheck": ["ci.typecheck.prepare", "ci.typecheck.run"],
      "ci.typecheck.prepare": "dialyzer --plt",
      "ci.typecheck.run": "dialyzer --no-check --halt-exit-status",
      "code.check": [
        "ci.compile",
        "ci.db",
        "ci.deps",
        "ci.docs",
        "ci.linters",
        "ci.test",
        "ci.typecheck"
      ],
      "code.fix": ["format"],
      "deps.compile": &deps_compile/1,
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.rollback": &ecto_rollback/1,
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      docs: &docs/1,
      main: ["code.fix", "code.check"],
      setup: ["deps.get", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  # Overrides the default `deps.compile` task to accept more options. Here are 
  # the new options it accepts:
  #
  # - `--ignore-warnings` - ignore all warnings
  defp deps_compile(args) do
    switches = [ignore_warnings: :boolean]
    {opts, remaining_args, _errors} = OptionParser.parse(args, strict: switches)

    if opts[:ignore_warnings] do
      {:ok, pid} = ExUnit.CaptureServer.start_link([])

      try do
        ExUnit.CaptureIO.capture_io(:stderr, fn ->
          Mix.Task.run("deps.compile", remaining_args)
        end)
      after
        GenServer.stop(pid)
      end
    else
      Mix.Task.run("deps.compile", remaining_args)
    end
  end

  # Overrides the default `docs` task to accept more options. Here are 
  # the new options it accepts:
  #
  # - `--warnings-as-errors` - if any warning is emmited, it raises the process
  defp docs(args) do
    switches = [warnings_as_errors: :boolean]
    {opts, remaining_args, _errors} = OptionParser.parse(args, strict: switches)

    {:ok, pid} = ExUnit.CaptureServer.start_link([])

    output =
      try do
        ExUnit.CaptureIO.capture_io(:stderr, fn ->
          Mix.Task.run("docs", remaining_args)
        end)
      after
        GenServer.stop(pid)
      end

    IO.puts(output)

    if opts[:warnings_as_errors] && output =~ "warning" do
      Mix.raise("There are warnings on the docs.")
    end
  end

  # Overrides the default `ecto.rollback` task to accept more options. Here are 
  # the new options it accepts:
  #
  # - `--check` - it setups the db and then run `mix ecto.rollback --all` to
  # check the migrations we have are all rollbackable
  defp ecto_rollback(args) do
    switches = [check: :boolean]
    {opts, remaining_args, _errors} = OptionParser.parse(args, strict: switches)

    if opts[:check] do
      # We run this through a separate mix process because otherwise the
      # rollback will throw warnings because the migration modules were
      # reloaded
      System.cmd("mix", ["ecto.setup"])
      Mix.Task.run("ecto.rollback", ["--all"])
      Mix.shell().info("Migrations checked! All of them are rollbackable.")
    else
      Mix.Task.run("ecto.rollback", remaining_args)
    end
  end
end
