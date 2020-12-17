defmodule WebService.Data do
  @moduledoc """
  Data retrieval, parsing and storage related functions.

  This module joins together the API and the Cache, in order to
  process concurrently the received cities.

  While the `fetch_city/1` function is enough to get the data
  of a city, it is suggested to call `populate/1` first,
  passing as the only argument an `Enum` containing the
  cities that will be used later.
  """

  alias WebService.Data.{API, Cache}

  @timeframe 60_000
  @max_requests 60

  # --- Public functions ---
  @doc """
  Process the cities and populate the cache concurrently, so that
  we avoid duplicated requests.

  While not strictly necessary, it is suggested to run this
  function if one knows previously what cities are required
  during the rest of the program execution.
  """
  @spec populate(Enumerable.t()) :: :ok
  def populate(cities) do
    chunks =
      cities
      |> Stream.chunk_every(@max_requests)
      |> Enum.to_list()

    {_, {count, _}} = Enum.map_reduce(chunks, {0, length(chunks) - 1}, &process_cities/2)

    "************************************************************************\n" <>
    "Se realizaron #{count} peticiones a la API.\n" <>
    "************************************************************************\n"
    |> IO.puts()
    :ok
  end

  @doc """
  Fetch the data of the city passed as an argument. The information
  will be retrieved from the cache if it has been previously stored
  or from the API.

  The results will be cached to avoid duplicated requests.
  """
  @spec fetch_city(map()) :: {:error, API.error(), map()} | {:ok, map(), map()}
  def fetch_city(city) do
    case fetch_city_from_cache(city) do
      {:error, :not_found} ->
        {code, data} = fetch_city_from_api(city)
        {code, data, city}
      {:ok, {code, data}} -> {code, data, city}
    end
  end

  # --- Private functions ---
  defp process_cities(cities, {counter, 0}) do
    do_process_cities(cities)

    {nil, {counter + length(cities), 0}}
  end
  defp process_cities(cities, {counter, i}) do
    do_process_cities(cities)

    IO.puts("\nDeteniendo peticiones por #{@timeframe / 1_000} segundos...\n")
    Process.sleep(@timeframe)
    {nil, {counter + length(cities), i-1}}
  end

  defp do_process_cities(cities) do
    Enum.map(cities, fn city ->
      IO.puts("Realizando petición a la API.")
      schedule(city)
    end)
    |> Task.yield_many(:infinity)
  end

  defp schedule(city) do
    Task.async(fn ->
      fetch_city_from_api(city)
    end)
  end

  defp fetch_city_from_api(%{iata: iata, lat: lat, lon: lon}) do
    response = API.by_coordinates(lat, lon)
    save_in_cache(iata, response)
  end
  defp fetch_city_from_api(%{name: name}) do
    response = API.by_name(name)
    save_in_cache(name, response)
  end

  defp fetch_city_from_cache(%{iata: iata}), do: Cache.fetch_city(iata)
  defp fetch_city_from_cache(%{name: name}), do: Cache.fetch_city(name)

  defp save_in_cache(key, value), do: Cache.put_city(key, value)
end
