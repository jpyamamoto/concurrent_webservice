defmodule WebServiceTest.Ticket do
  use ExUnit.Case

  alias WebService.{Airport, Weather}
  import Mock

  @airport1 %Airport{name: nil, lon: -103.31099700927734, lat: 20.521799087524414, iata: "GDL"}
  @airport2 %Airport{name: nil, lon: -99.072098, lat: 19.4363, iata: "MEX"}
  @fake_weather %Weather{name: "", lon: 0, lat: 0, temp: 28, temp_min: 12, temp_max: 30, humidity: 15}

  test "prints info correctly" do
    with_mocks([{Stream, [], [run: fn x -> Enum.to_list(x) |> Enum.join("\n") end, map: &Enum.map/2]},
                {IO, [], [puts: fn(str) -> str end]},
                {WebService.Data, [], [fetch_city: fn (%Airport{name: name, lon: lon, lat: lat} = airport) ->
                                        {:ok, %Weather{@fake_weather | name: name, lon: lon, lat: lat}, airport}
                                      end]}
               ]) do
      assert WebService.Ticket.process([{@airport1, @airport2}]) == "------------------------------------------------------------------------\n" <>
        "Origen: \n" <>
        "    - Temperatura actual: 28 °C\n" <>
        "    - Temperatura mínima: 12 °C\n" <>
        "    - Temperatura máxima: 30 °C\n" <>
        "    - Humedad: 15%\n" <>
        "Destino: \n" <>
        "    - Temperatura actual: 28 °C\n" <>
        "    - Temperatura mínima: 12 °C\n"<>
        "    - Temperatura máxima: 30 °C\n" <>
        "    - Humedad: 15%\n" <>
        "------------------------------------------------------------------------\n"
    end
  end
end
