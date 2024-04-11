defmodule WebService.Airport do
  @moduledoc """
  Functions related to the retrieval of airport's data.

  This module takes advantage of Elixir's metaprogramming capabilities.
  """

  @type t() :: %__MODULE__{
    name: String.t() | nil,
    lat: number() | nil,
    lon: number() | nil,
    iata: String.t() | nil
  }

  defstruct [:name, :lon, :lat, :iata]

  @external_resource "priv/airports.csv"

  @doc """
  Retrieve information about an airport given its IATA code.

  Example:
    > airport_from_iata("MEX")
    > %{
        iata: "MEX",
        lat: 19.4363,
        lon: -99.072098,
        name: "Licenciado Benito Juarez International Airport"
      }

  This function is defined at compile time, so that we don't spend
  time parsing the source file during execution.

  We use the "priv/airports.csv" file as a source to retrieve the
  IATA codes of the airports.

  *Recompilation is required whenever that file is modified.*
  """
  @spec airport_from_iata(String.t()) :: nil | t()

  @external_resource
  |> File.stream!()
  |> CSV.decode(headers: true)
  |> Stream.map(fn {_, data} -> data end)
  |> Stream.filter(fn %{"iata_code" => iata} -> iata != "" end)
  |> Stream.uniq_by(fn %{"iata_code" => iata} -> iata end)
  |> Stream.map(fn %{"coordinates" => coords} = airport ->
    {lat, lon} =
      String.split(coords, ", ")
      |> Enum.map(&Float.parse/1)
      |> Enum.map(&(elem(&1, 0)))
      |> List.to_tuple()

    Map.merge(airport, %{"lat" => lat, "lon" => lon})
  end)
  |> Enum.each(fn %{"iata_code" => iata, "name" => name, "lat" => lat, "lon" => lon} ->
    def airport_from_iata(unquote(iata)) do
      %__MODULE__{name: unquote(name), iata: unquote(iata), lat: unquote(lat), lon: unquote(lon)}
    end
  end)

  def airport_from_iata(_), do: nil
end
