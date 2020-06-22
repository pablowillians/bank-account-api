# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :bank_account,
  ecto_repos: [BankAccount.Repo]

config :bank_account_web,
  ecto_repos: [BankAccount.Repo],
  generators: [context_app: :bank_account, binary_id: true]

# Configures the endpoint
config :bank_account_web, BankAccountWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tZx/akUuyYEtq23BfzFvIg4fu/EXVMuhwJFzHnSLcF7suRQ1NXOi9qGwqxXbvSZE",
  render_errors: [view: BankAccountWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: BankAccount.PubSub,
  live_view: [signing_salt: "sxQKYB9U"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
