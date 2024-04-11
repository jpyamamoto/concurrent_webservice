defmodule WebService.Ticket do
  @moduledoc """
  Process the tickets and print the information to the console.

  The information is retrieved from `WebService.Data`.
  """

  alias WebService.Data
  alias WebService.Airport

  @enforce_keys [:origin, :destination]
  defstruct [:origin, :destination]

  @type t() :: %__MODULE__{
    origin: Airport.t(),
    destination: Airport.t()
  }

  # --- Public functions ---
  @doc """
  Process the tickets by fetching the data and printing the
  responses to the console.
  """
  @spec process(Enumerable.t()) :: :ok
  def process(tickets) do
    tickets
    |> Stream.map(fn {origin, destination} ->
      %__MODULE__{origin: Data.fetch_city(origin), destination: Data.fetch_city(destination)}
    end)
    |> Stream.map(&print_info/1)
    |> Stream.run()
  end

  # --- Printing related functions ---
  defp print_info(%__MODULE__{origin: origin_info, destination: dest_info}) do
    print_features(info_airport(origin_info), info_airport(dest_info))
  end

  defp info_airport({:ok, weather, airport}) do
    {get_identity(airport), string_city(weather)}
  end
  defp info_airport({:error, error, airport}) do
    {"Ocurrió un error al obtener #{get_identity(airport)}", string_error(error)}
  end

  defp print_features({origin_name, origin_string}, {dest_name, dest_string}) do
    ticket_string =
      "------------------------------------------------------------------------\n" <>
      "Origen: #{origin_name}\n" <>
      "    - #{origin_string}\n" <>
      "Destino: #{dest_name}\n" <>
      "    - #{dest_string}\n" <>
      "------------------------------------------------------------------------\n"

    IO.puts ticket_string
  end

  defp string_city(weather) do
    "Temperatura actual: #{weather.temp} °C\n" <>
    "    - Temperatura mínima: #{weather.temp_min} °C\n" <>
    "    - Temperatura máxima: #{weather.temp_max} °C\n" <>
    "    - Humedad: #{weather.humidity}%"
  end

  defp string_error(:not_found), do: "La ciudad no está en el API o no existe."
  defp string_error(:invalid_appid), do: "La API KEY es inválida."
  defp string_error(:limit_hit), do: "El límite de peticiones al servidor se rebasó."
  defp string_error(:request), do: "Hubo un error en el servidor al hacer la petición."
  defp string_error(:invalid_json), do: "JSON inválido."

  defp get_identity(%Airport{name: name}), do: name
  defp get_identity(%Airport{iata: iata}), do: iata
end
