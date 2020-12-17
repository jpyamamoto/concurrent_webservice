defmodule WebService.Parsing do
  @moduledoc """
  Functions related to parsing of files.
  """

  @default_origin "MEX"

  # --- Public functions ---
  @doc """
  Decode a CSV into a map, using the first line of the file
  as the headers.
  """
  @spec csv_to_map(Enumerable.t()) :: Enumerable.t()
  def csv_to_map(file), do: CSV.decode(file, headers: true)

  @doc """
  Depending on the input, pattern match on the fields that are
  usefull, and ignore everything else.
  Strings are normalized and coordinates are given as floats.
  """
  @spec parse_line({atom(), map()}) :: {map(), map()}
  def parse_line({:ok, %{"origin" => origin, "destination" => destination, "origin_latitude" => lat1,
                     "origin_longitude" => lon1, "destination_latitude" => lat2, "destination_longitude" => lon2}}) do
    origin_airport = %{iata: origin, lat: to_float(lat1), lon: to_float(lon1)}
    destination_airport = %{iata: destination, lat: to_float(lat2), lon: to_float(lon2)}
    {origin_airport, destination_airport}
  end
  def parse_line({:ok, %{"destino" => destination}}) do
    {%{iata: @default_origin, lat: nil, lon: nil}, %{name: normalize(destination), lat: nil, lon: nil}}
  end

  @doc """
  When the IATA code is given, retrieve its latitude and longitude.
  """
  @spec use_iata_codes({map(), map()}) :: {map(), map()}
  def use_iata_codes({origin, destination}) do
    {lat1, lon1} = get_coords(origin)
    {lat2, lon2} = get_coords(destination)
    {%{origin | lat: lat1, lon: lon1}, %{destination | lat: lat2, lon: lon2}}
  end

  # --- Private functions ---
  defp to_float(number) when is_binary(number), do: number |> Float.parse() |> elem(0)

  defp get_coords(%{iata: iata, lat: lat, lon: lon}) do
    case WebService.Airports.airport_from_iata(iata) do
      %{lat: new_lat, lon: new_lon} ->
        {new_lat, new_lon}
      nil ->
        {lat, lon}
    end
  end
  defp get_coords(_), do: {nil, nil}

  defp normalize(string) do
    string
    |> String.normalize(:nfd)
    |> String.replace(~r/[^A-z\s]/u, "")
    |> String.replace(~r/\s/, " ")
    |> String.downcase()
  end
end
