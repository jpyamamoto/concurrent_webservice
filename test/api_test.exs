defmodule WebServiceTest.Data.API do
  use ExUnit.Case

  @test_places [
    %{name: "Coyoacán", lat: 19.3289, lon: -99.1603},
    %{name: "Paris", lat: 48.8534, lon: 2.3488},
    %{name: "Sydney", lat: -33.8679, lon: 151.2073},
    %{name: "London", lat: 51.5085, lon: -0.1257},
    %{name: "Miami", lat: 25.7743, lon: -80.1937},
    %{name: "Dubai", lat: 25.2582, lon: 55.3047},
    %{name: "Shanghai", lat: 31.2222, lon: 121.4581},
  ]

  test "test request by coords", _ do
    @test_places
    |> Enum.each(fn %{name: name, lat: lat, lon: lon} ->
      {:ok, %{"name" => res_name}} = WebService.Data.API.by_coordinates(lat, lon)
      assert name == res_name
    end)
  end

  test "test request by name", _ do
    @test_places
    |> Enum.each(fn %{name: name, lat: lat, lon: lon} ->
      {:ok, %{"coord" => %{"lat" => lat_res, "lon" => lon_res}}} = WebService.Data.API.by_name(name)
      assert abs(lat - lat_res) < 0.05
      assert abs(lon - lon_res) < 0.05
    end)
  end
end
