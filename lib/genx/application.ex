defmodule Genx.Application do
  @moduledoc """
  The Genx.Application is the module with the code for starting up the
  app.

  It has the `start` function that is configured on `mix.exs` as the entry
  point of the application. And the `config_change` function that is called
  after a code upgrade if the application environment (`Application.get_env` 
  and such) changed.

  It implements the `Application` behaviour, so if you want to dive deeper on
  how it works, it might be helpful to give that a check.
  """

  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      Genx.Repo,
      GenxWeb.Telemetry,
      {Phoenix.PubSub, name: Genx.PubSub},
      GenxWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Genx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl Application
  def config_change(changed, _new, removed) do
    GenxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
