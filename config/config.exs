# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hermus,
  ecto_repos: [Hermus.Repo]

# Configures the endpoint
config :hermus, HermusWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kytXTF6T1+ZK9R7X365R9hPxcREuUv1/dfOq4cLhpFc9LMNHmWmqq6KDWgKGFAsf",
  render_errors: [view: HermusWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Hermus.PubSub,
  live_view: [signing_salt: "7C1MZO/f"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
