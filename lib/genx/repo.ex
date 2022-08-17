defmodule Genx.Repo do
  @moduledoc """
  The Repo is responsible for managing the database connections and executing 
  the queries and commands on it.
  """

  use Ecto.Repo,
    otp_app: :genx,
    adapter: Ecto.Adapters.Postgres
end
