defmodule Genx.ApplicationTest do
  use ExUnit.Case

  alias Genx.Application
  alias GenxWeb.Endpoint

  describe "config_change/3" do
    test "updates the endpoint config" do
      old_config =
        Endpoint
        |> :ets.select([{{:"$1", :"$2"}, [], [:"$$"]}])
        |> Enum.map(fn [k, v] -> {k, v} end)

      Application.config_change([{Endpoint, [{:random, "1234"} | old_config]}], nil, [])
      assert Endpoint.config(:random, nil) == "1234"
    end
  end
end
