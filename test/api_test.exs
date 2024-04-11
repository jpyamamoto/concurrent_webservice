defmodule WebServiceTest.Data.API do
  use ExUnit.Case

  alias WebService.{Airport, Weather}
  import Mock

  @test_places [
    %Airport{name: "Coyoacán", lat: 19.3289, lon: -99.1603},
    %Airport{name: "Paris", lat: 48.8534, lon: 2.3488},
    %Airport{name: "Sydney", lat: -33.8679, lon: 151.2073},
    %Airport{name: "London", lat: 51.5085, lon: -0.1257},
    %Airport{name: "Miami", lat: 25.7743, lon: -80.1937},
    %Airport{name: "Dubai", lat: 25.2582, lon: 55.3047},
    %Airport{name: "Shanghai", lat: 31.2222, lon: 121.4581},
  ]

  test "test request by coords", _ do
    @test_places
    |> Enum.each(fn %Airport{name: name, lat: lat, lon: lon} ->
      {:ok, %Weather{name: res_name}} = WebService.Data.API.by_coordinates(lat, lon)
      assert name == res_name
    end)
  end

  test "test request by name", _ do
    @test_places
    |> Enum.each(fn %Airport{name: name, lat: lat, lon: lon} ->
      {:ok, %Weather{lat: lat_res, lon: lon_res}} = WebService.Data.API.by_name(name)
      assert is_number(lat_res)
      assert is_number(lon_res)
      assert abs(lat - lat_res) < 0.05
      assert abs(lon - lon_res) < 0.05
    end)
  end

  test "failed request: 400" do
    with_mock HTTPoison, [get: fn(_url) -> {:ok, %HTTPoison.Response{status_code: 400, body: "Not found"}} end] do
      assert WebService.Data.API.by_name("Invalid") == {:error, :not_found}
    end
  end

  test "failed request: 401" do
    with_mock HTTPoison, [get: fn(_url) -> {:ok, %HTTPoison.Response{status_code: 401, body: "Invalid AppId"}} end] do
      assert WebService.Data.API.by_name("Invalid") == {:error, :invalid_appid}
    end
  end

  test "failed request: 404" do
    with_mock HTTPoison, [get: fn(_url) -> {:ok, %HTTPoison.Response{status_code: 404, body: "Not Found"}} end] do
      assert WebService.Data.API.by_name("Invalid") == {:error, :not_found}
    end
  end

  test "failed request: 429" do
    with_mock HTTPoison, [get: fn(_url) -> {:ok, %HTTPoison.Response{status_code: 429, body: "Not Found"}} end] do
      assert WebService.Data.API.by_name("Invalid") == {:error, :limit_hit}
    end
  end
end
