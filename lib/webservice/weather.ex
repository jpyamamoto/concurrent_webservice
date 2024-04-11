defmodule WebService.Weather do
  @type t() :: %__MODULE__{
    temp: number(),
    temp_min: number(),
    temp_max: number(),
    humidity: number(),
    lat: number(),
    lon: number(),
    name: String.t()
  }

  @enforce_keys [:temp, :temp_min, :temp_max, :humidity, :lat, :lon, :name]
  defstruct [:temp, :temp_min, :temp_max, :humidity, :lat, :lon, :name]
end
