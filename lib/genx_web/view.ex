defmodule GenxWeb.View do
  @moduledoc false

  @doc """
  Configures the module where it's used as a view
  """
  defmacro __using__(_opts) do
    quote do
      use Phoenix.View, root: "lib/genx_web/templates", namespace: GenxWeb
    end
  end
end
