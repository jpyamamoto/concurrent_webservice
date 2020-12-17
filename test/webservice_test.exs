defmodule WebServiceTest do
  use ExUnit.Case
  doctest WebService

  @airports [
    {"MEX", %{lat: 19.4363, lon: -99.072098}},
    {"MTY", %{lat: 25.7784996033, lon: -100.107002258}},
    {"TLC", %{lat: 19.3370990753, lon: -99.56600189210002}},
    {"TAM", %{lat: 22.2964000702, lon: -97.8658981323}},
    {"GDL", %{lat: 20.521799087524414, lon: -103.31099700927734}},
    {"LIM", %{lat: -12.0219, lon: -77.114305}},
    {"MIA", %{lat: 25.79319953918457, lon: -80.29060363769531}},
    {"DFW", %{lat: 32.896801, lon: -97.038002}},
    {"SLP", %{lat: 22.254299163800003, lon: -100.930999756}},
    {"LAX", %{lat: 33.94250107, lon: -118.4079971}},
    {"CLT", %{lat: 35.2140007019043, lon: -80.94309997558594}},
    {"YYZ", %{lat: 43.6772003174, lon: -79.63059997559999}},
    {"CUN", %{lat: 21.036500930800003, lon: -86.8770980835}},
    {"IAH", %{lat: 29.984399795532227, lon: -95.34140014648438}},
    {"YVR", %{lat: 49.193901062, lon: -123.183998108}},
    {"CDG", %{lat: 49.012798, lon: 2.55}},
  ]

  def get_test_airports(), do: @airports

  def random_code do
    key = ?A..?Z |> Enum.shuffle() |> Enum.slice(0, 3)

    if Enum.any?(@airports, &(&1 == key)) do
      random_code()
    else
      key
    end
  end
end
