defmodule GenxWeb.RouterTest do
  use GenxWeb.ConnCase

  import Phoenix.LiveViewTest

  test "browser requests only accept html", %{conn: conn} do
    msg = ~s(unknown format "json", expected one of ["html"])
    assert_raise Phoenix.NotAcceptableError, msg, fn -> live(conn, "/?_format=json") end
  end

  test "adds live dashboard route", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/dashboard/home")
    assert html =~ "Phoenix LiveDashboard"
  end
end
