defmodule GenxWeb.Telemetry do
  @moduledoc false

  use Supervisor
  import Telemetry.Metrics

  @type metric :: Telemetry.Metrics.t()
  @type on_start :: Supervisor.on_start()

  @doc """
  Starts the supervisor responsible for managing the telemetry processes
  """
  @spec start_link(any) :: on_start
  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl Supervisor
  def init(_arg) do
    children = [
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @doc """
  Returns the list of metrics tracked in the system
  """
  @spec metrics() :: [metric]
  def metrics do
    [
      # Phoenix Metrics
      summary("phoenix.endpoint.stop.duration",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.stop.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),

      # Database Metrics
      summary("genx.repo.query.total_time",
        unit: {:native, :millisecond},
        description: "The sum of the other measurements"
      ),
      summary("genx.repo.query.decode_time",
        unit: {:native, :millisecond},
        description: "The time spent decoding the data received from the database"
      ),
      summary("genx.repo.query.query_time",
        unit: {:native, :millisecond},
        description: "The time spent executing the query"
      ),
      summary("genx.repo.query.queue_time",
        unit: {:native, :millisecond},
        description: "The time spent waiting for a database connection"
      ),
      summary("genx.repo.query.idle_time",
        unit: {:native, :millisecond},
        description:
          "The time the connection spent waiting before being checked out for the query"
      ),

      # VM Metrics
      summary("vm.memory.total", unit: {:byte, :kilobyte}),
      summary("vm.total_run_queue_lengths.total"),
      summary("vm.total_run_queue_lengths.cpu"),
      summary("vm.total_run_queue_lengths.io")
    ]
  end

  # Returns a list of periodic measurements.
  #
  # Each item on the list should be the module, function and arguments to be
  # invoked periodically. The given function must call `:telemetry.execute/3`
  # and a metric must be added on the `metrics` function of this module.
  @spec periodic_measurements() :: [{module, atom, list}]
  defp periodic_measurements do
    [
      # {GenxWeb, :count_users, []}
    ]
  end
end
