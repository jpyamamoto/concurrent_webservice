defmodule WebServiceTest.Airports do
  use ExUnit.Case

  test "iata returns correct coords", _ do
    WebServiceTest.get_test_airports()
    |> Enum.shuffle()
    |> Enum.map(fn {iata, %{lat: lat_t, lon: lon_t}} ->
      %{lat: lat, lon: lon} = WebService.Airports.airport_from_iata(iata)
      assert lat == lat_t
      assert lon == lon_t
    end)
  end

  test "non-existent airports return nil", _ do
    Enum.map(1..20, fn _ ->
      assert WebService.Airports.airport_from_iata(WebServiceTest.random_code()) == nil
    end)
  end
end
