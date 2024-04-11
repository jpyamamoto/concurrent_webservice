import Config

config :webservice,
  timeframe: 60_000,
  max_requests: 60

import_config "#{config_env()}.exs"
