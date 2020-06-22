use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :bank_account, BankAccount.Repo,
  username: System.get_env("POSTGRES_USERNAME", "postgres"),
  password: System.get_env("POSTGRES_PASSWORD", "postgres"),
  database: System.get_env("POSTGRES_USERNAME", "postgres") <> "_" <> System.get_env("MIX_ENV", "dev"),
  hostname: System.get_env("POSTGRES_HOST", "db"),
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bank_account_web, BankAccountWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
