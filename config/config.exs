# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
#config :lonestarelixir,
#  ecto_repos: [Lonestarelixir.Repo]

# Configures the endpoint
config :lonestarelixir, Lonestarelixir.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "76ymM0zqnRrqU9Em2hOIWTvwl/U9riCRz74evFTclBHcXBewCELYhl1P5nW2IQ8Z",
  render_errors: [view: Lonestarelixir.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Lonestarelixir.PubSub,
  adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
