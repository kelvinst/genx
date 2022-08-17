defmodule Genx.ReleaseTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO
  import Genx.Release

  alias Ecto.Adapters.SQL.Sandbox
  alias Genx.Repo

  setup do
    Sandbox.mode(Repo, :auto)

    on_exit(fn ->
      capture_io(:stderr, fn -> migrate() end)
      Sandbox.mode(Repo, :manual)
    end)
  end

  test "migrate/2 migrates the db" do
    # capturing IO to not print warnings
    capture_io(:stderr, fn ->
      rollback(Repo, 20_210_810_192_556)
      assert migrate() == %{Repo => []}
    end)
  end

  test "rollback/2 rolls back the db to the given version" do
    # capturing IO to not print warnings
    capture_io(:stderr, fn ->
      assert rollback(Repo, 20_210_810_192_556) == %{Repo => []}
    end)
  end
end
