defmodule WebServiceTest.Data.Cache do
  use ExUnit.Case

  setup do
    WebService.Data.Cache.start_link([])
    %{}
  end

  test "cache cities", _ do
    WebServiceTest.get_test_airports()
    |> Enum.shuffle()
    |> Enum.map(fn {key, _} ->
      assert WebService.Data.Cache.fetch_city(key) == {:error, :not_found}
    end)

    WebServiceTest.get_test_airports()
    |> Enum.shuffle()
    |> Enum.map(fn {key, value} ->
      assert WebService.Data.Cache.put_city(key, value)
    end)

    WebServiceTest.get_test_airports()
    |> Enum.shuffle()
    |> Enum.map(fn {key, value} ->
      assert WebService.Data.Cache.fetch_city(key) == {:ok, value}
    end)
  end

  test "non-existent cities", _ do
    Enum.map(1..20, fn _ ->
      assert WebService.Data.Cache.fetch_city(WebServiceTest.random_code()) == {:error, :not_found}
    end)
  end
end
