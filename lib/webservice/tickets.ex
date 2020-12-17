defmodule WebService.Tickets do
  @moduledoc """
  Process the tickets and print the information to the console.

  The information is retrieved from `WebService.Data`.
  """

  alias WebService.Data

  # --- Public functions ---
  @doc """
  Process the tickets by fetching the data and printing the
  responses to the console.
  """
  @spec process(Enumerable.t()) :: :ok
  def process(tickets) do
    tickets
    |> Stream.map(fn {origin, destination} -> {Data.fetch_city(origin), Data.fetch_city(destination)} end)
    |> Stream.map(&print_info/1)
    |> Stream.run()
  end

  # --- Printing related functions ---
  defp print_info({{:ok, json_origin, origin}, {:ok, json_destination, destination}}) do
    origin_name = get_identity(origin)
    destination_name = get_identity(destination)
    features_origin = get_features(json_origin) |> string_city()
    features_destination = get_features(json_destination) |> string_city()
    print_features({origin_name, features_origin}, {destination_name, features_destination})
  end
  defp print_info({{:error, error_origin, origin}, {:error, error_dest, dest}}) do
    origin_name = "Ocurrió un error al obtener #{get_identity(origin)}"
    destination_name = "Ocurrió un error al obtener #{get_identity(dest)}"
    string_error_origin = string_error(error_origin)
    string_error_dest = string_error(error_dest)
    print_features({origin_name, string_error_origin}, {destination_name, string_error_dest})
  end
  defp print_info({{:error, error, origin}, {:ok, json, dest}}) do
    origin_name = "Ocurrió un error al obtener #{get_identity(origin)}"
    destination_name = get_identity(dest)
    string_origin = string_error(error)
    string_dest = get_features(json) |> string_city()
    print_features({origin_name, string_origin}, {destination_name, string_dest})
  end
  defp print_info({{:ok, json, origin}, {:error, error, dest}}) do
    origin_name = get_identity(origin)
    destination_name = "Ocurrió un error al obtener #{get_identity(dest)}"
    string_origin = get_features(json) |> string_city()
    string_dest = string_error(error)
    print_features({origin_name, string_origin}, {destination_name, string_dest})
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

  defp string_city({temp, temp_min, temp_max, humidity}) do
    "Temperatura actual: #{temp} °C\n" <>
    "    - Temperatura mínima: #{temp_min} °C\n" <>
    "    - Temperatura máxima: #{temp_max} °C\n" <>
    "    - Humedad: #{humidity}%"
  end

  defp string_error(:not_found), do: "La ciudad no está en el API o no existe."
  defp string_error(:invalid_appid), do: "La API KEY es inválida."
  defp string_error(:limit_hit), do: "El límite de peticiones al servidor se rebasó."
  defp string_error(:request), do: "Hubo un error en el servidor al hacer la petición."
  defp string_error(:invalid_json), do: "JSON inválido."

  defp get_identity(%{name: name}), do: name
  defp get_identity(%{iata: iata}), do: iata

  defp get_features(%{"main" => main}) do
    %{"temp" => temp, "temp_min" => temp_min, "temp_max" => temp_max, "humidity" => humidity} = main
    {temp, temp_min, temp_max, humidity}
  end
end
