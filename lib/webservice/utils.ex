defmodule WebService.Utils do

  def get_appid(), do: Application.fetch_env!(:webservice, :openweather_appid)

  def get_timeframe(), do: Application.fetch_env!(:webservice, :timeframe)

  def get_max_requests(), do: Application.fetch_env!(:webservice, :max_requests)

end
