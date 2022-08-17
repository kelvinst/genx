defmodule GenxWeb.LayoutView do
  @moduledoc false

  use GenxWeb.View
  use Phoenix.HTML

  import Phoenix.LiveView.Helpers
  import Phoenix.Controller, only: [get_flash: 2]

  alias GenxWeb.Router.Helpers, as: Routes

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}
end
