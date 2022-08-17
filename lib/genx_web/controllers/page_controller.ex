defmodule GenxWeb.PageController do
  @moduledoc false

  use GenxWeb.Controller

  @type conn :: Plug.Conn.t()

  @doc "The main page for the app"
  @spec index(conn, map) :: conn
  def index(conn, _params) do
    render(conn, "index.html")
  end
end
