import Config
import Dotenvy

source!([".env", System.get_env()])

config :webservice,
  openweather_appid: env!("OPENWEATHER_APPID", :string!)
