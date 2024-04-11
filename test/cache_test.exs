defmodule WebServiceTest.Data.Cache do
  use ExUnit.Case

  alias WebService.Airport

  setup do
    WebService.Data.Cache.start_link([])
    %{}
  end

  test "cache cities", _ do
    WebService.Data.Cache.clean_cache()

    WebServiceTest.get_test_airports()
    |> Enum.shuffle()
    |> Enum.map(fn %Airport{iata: iata} ->
      assert WebService.Data.Cache.fetch_city(iata) == {:error, :not_found}
    end)

    WebServiceTest.get_test_airports()
    |> Enum.shuffle()
    |> Enum.map(fn (%Airport{iata: iata} = airport) ->
      assert WebService.Data.Cache.put_city(iata, airport)
    end)

    WebServiceTest.get_test_airports()
    |> Enum.shuffle()
    |> Enum.map(fn (%Airport{iata: iata} = airport) ->
      assert WebService.Data.Cache.fetch_city(iata) == {:ok, airport}
    end)
  end

  test "non-existent cities", _ do
    Enum.map(1..20, fn _ ->
      assert WebService.Data.Cache.fetch_city(WebServiceTest.random_code()) == {:error, :not_found}
    end)
  end
end
