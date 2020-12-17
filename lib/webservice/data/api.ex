defmodule WebService.Data.API do
  @moduledoc """
  OpenWeatherMap API related functions.
  """

  @type error() :: :not_found | :invalid_appid | :limit_hit | :request | :invalid_json
  @base_url "https://api.openweathermap.org/data/2.5"
  @appid "f6b94161f50fb567c57586e092fa7ad3"

  # --- Public functions ---
  @doc """
  Retrieve the data provided by OpenWeatherMap, given the coordinates
  of a place.
  """
  @spec by_coordinates(number, number) :: {:ok, map} | {:error, error()}
  def by_coordinates(lat, lon) when is_number(lat) and is_number(lon), do: make_request({lat, lon})

  @doc """
  Retrieve the data provided by OpenWeatherMap, given the name
  of a place.
  """
  @spec by_name(String.t()) :: {:ok, map} | {:error, error()}
  def by_name(name) when is_binary(name), do: make_request(name)

  # --- Private functions ---
  defp make_request(args) do
    args
    |> prepare_url()
    |> request_data()
    |> parse_response()
    |> parse_json()
  end

  defp prepare_url({latitude, longitude}) do
    @base_url <> "/weather?lat=#{latitude}&lon=#{longitude}&units=metric&lang=es&appid=#{@appid}"
  end
  defp prepare_url(name) do
    @base_url <> "/weather?q=#{name}&units=metric&lang=es&appid=#{@appid}"
  end

  defp request_data(url), do: HTTPoison.get(url)

  # Errors described in https://openweathermap.org/faq
  defp parse_response({:ok, %HTTPoison.Response{status_code: 200, body: response}}), do: {:ok, response}
  defp parse_response({:ok, %HTTPoison.Response{status_code: 400}}), do: {:error, :not_found}
  defp parse_response({:ok, %HTTPoison.Response{status_code: 401}}), do: {:error, :invalid_appid}
  defp parse_response({:ok, %HTTPoison.Response{status_code: 404}}), do: {:error, :not_found}
  defp parse_response({:ok, %HTTPoison.Response{status_code: 429}}), do: {:error, :limit_hit}
  defp parse_response({:error, _}), do: {:error, :request}

  defp parse_json({:error, _} = args), do: args
  defp parse_json({:ok, response}) do
    case Poison.decode(response) do
      {:ok, json} -> {:ok, json}
      {:error, _} -> {:error, :invalid_json}
    end
  end
end
