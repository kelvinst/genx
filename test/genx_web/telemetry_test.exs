defmodule GenxWeb.TelemetryTest do
  use ExUnit.Case

  # Aliased before the `GenxWeb.Telemetry` because if we alias that one
  # first this one would alias `GenxWeb.Telemetry.Metrics.Summary`
  alias Telemetry.Metrics.Summary

  alias GenxWeb.Telemetry

  describe "metrics/0" do
    test "returns a list of metrics to be gathered" do
      assert [
               endpoint_stop,
               router_stop,
               query_total_time,
               query_decode_time,
               query_time,
               query_queue_time,
               query_idle_time,
               memory_total,
               run_queue_total,
               run_queue_cpu,
               run_queue_io
             ] = Telemetry.metrics()

      assert %Summary{
               name: [:phoenix, :endpoint, :stop, :duration],
               event_name: [:phoenix, :endpoint, :stop],
               tags: [],
               keep: nil,
               description: nil,
               unit: :millisecond,
               reporter_options: []
             } = endpoint_stop

      assert %Summary{
               name: [:phoenix, :router_dispatch, :stop, :duration],
               event_name: [:phoenix, :router_dispatch, :stop],
               tags: [:route],
               keep: nil,
               description: nil,
               unit: :millisecond,
               reporter_options: []
             } = router_stop

      assert %Summary{
               name: [:genx, :repo, :query, :total_time],
               event_name: [:genx, :repo, :query],
               tags: [],
               keep: nil,
               description: "The sum of the other measurements",
               unit: :millisecond,
               reporter_options: []
             } = query_total_time

      assert %Summary{
               name: [:genx, :repo, :query, :decode_time],
               event_name: [:genx, :repo, :query],
               tags: [],
               keep: nil,
               description: "The time spent decoding the data received from the database",
               unit: :millisecond,
               reporter_options: []
             } = query_decode_time

      assert %Summary{
               name: [:genx, :repo, :query, :query_time],
               event_name: [:genx, :repo, :query],
               tags: [],
               keep: nil,
               description: "The time spent executing the query",
               unit: :millisecond,
               reporter_options: []
             } = query_time

      assert %Summary{
               name: [:genx, :repo, :query, :queue_time],
               event_name: [:genx, :repo, :query],
               tags: [],
               keep: nil,
               description: "The time spent waiting for a database connection",
               unit: :millisecond,
               reporter_options: []
             } = query_queue_time

      assert %Summary{
               name: [:genx, :repo, :query, :idle_time],
               event_name: [:genx, :repo, :query],
               tags: [],
               keep: nil,
               description:
                 "The time the connection spent waiting before being checked out for the query",
               unit: :millisecond,
               reporter_options: []
             } = query_idle_time

      assert %Summary{
               name: [:vm, :memory, :total],
               event_name: [:vm, :memory],
               tags: [],
               keep: nil,
               description: nil,
               unit: :kilobyte,
               reporter_options: []
             } = memory_total

      assert %Summary{
               name: [:vm, :total_run_queue_lengths, :total],
               event_name: [:vm, :total_run_queue_lengths],
               measurement: :total,
               tags: [],
               keep: nil,
               description: nil,
               unit: :unit,
               reporter_options: []
             } = run_queue_total

      assert %Summary{
               name: [:vm, :total_run_queue_lengths, :cpu],
               event_name: [:vm, :total_run_queue_lengths],
               measurement: :cpu,
               tags: [],
               keep: nil,
               description: nil,
               unit: :unit,
               reporter_options: []
             } = run_queue_cpu

      assert %Summary{
               name: [:vm, :total_run_queue_lengths, :io],
               event_name: [:vm, :total_run_queue_lengths],
               measurement: :io,
               tags: [],
               keep: nil,
               description: nil,
               unit: :unit,
               reporter_options: []
             } = run_queue_io
    end
  end
end
