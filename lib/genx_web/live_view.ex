defmodule GenxWeb.LiveView do
  @moduledoc false

  @doc """
  Configures the module where it's used as a live view
  """
  defmacro __using__(_opts) do
    quote do
      use Phoenix.LiveView,
        layout: {GenxWeb.LayoutView, "live.html"}
    end
  end
end
