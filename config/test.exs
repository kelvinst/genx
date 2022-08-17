import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :genx, Genx.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "genx_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :genx, GenxWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "NG+uX5sx1GIjmmkuNkCqDPAGrmpRe9+LGAdCVjOL+ScwmjIh4l5U1MNNyVBCf2wa",
  server: false

# In test we don't send emails.
config :genx, Genx.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
