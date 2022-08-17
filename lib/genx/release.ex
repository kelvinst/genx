defmodule Genx.Release do
  # Used for executing DB release tasks when run in production without Mix
  # installed.
  @moduledoc false

  @app :genx

  @doc """
  Run all pending migrations on all repos of the system
  """
  @spec migrate() :: %{module => [integer]}
  def migrate do
    load_app()

    for repo <- repos(), into: %{} do
      {:ok, result, _apps} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
      {repo, result}
    end
  end

  @doc """
  Rollback the migration of the given `v` on the given `repo`
  """
  @spec rollback(module, String.t()) :: %{module => [integer]}
  def rollback(repo, v) do
    load_app()
    {:ok, result, _apps} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: v))
    %{repo => result}
  end

  @spec repos() :: [module]
  defp repos, do: Application.fetch_env!(@app, :ecto_repos)

  @spec load_app() :: :ok
  defp load_app, do: Application.load(@app)
end
