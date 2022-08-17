defmodule Genx.DataCase do
  @moduledoc false

  # This module defines the setup for tests requiring
  # access to the application's data layer.

  # You may define functions here to be used as helpers in
  # your tests.

  # Finally, if the test case interacts with the database,
  # we enable the SQL sandbox, so changes done to the database
  # are reverted at the end of every test. If you are using
  # PostgreSQL, you can even run database tests asynchronously
  # by setting `use Genx.DataCase, async: true`, although
  # this option is not recommended for other databases.

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox
  alias Ecto.Changeset
  alias Genx.Repo

  @type changeset :: Ecto.Changeset.t()

  using do
    quote do
      alias Genx.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Genx.DataCase
    end
  end

  setup tags do
    Genx.DataCase.setup_sandbox(tags)
    :ok
  end

  @doc """
  Sets up the sandbox based on the test tags.
  """
  @spec setup_sandbox(Keyword.t()) :: :ok
  def setup_sandbox(tags) do
    pid = Sandbox.start_owner!(Repo, shared: not tags[:async])
    on_exit(fn -> Sandbox.stop_owner(pid) end)
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  @spec errors_on(changeset) :: %{required(atom) => [term]}
  def errors_on(changeset) do
    Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _whole_match, key ->
        atom_key = String.to_existing_atom(key)
        opts |> Keyword.get(atom_key, key) |> to_string()
      end)
    end)
  end
end
