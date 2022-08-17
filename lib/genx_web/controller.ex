defmodule GenxWeb.Controller do
  @moduledoc false

  @doc """
  Configures the module where it's used as a controller
  """
  defmacro __using__(_opts) do
    quote do
      use Phoenix.Controller, namespace: GenxWeb
    end
  end
end
