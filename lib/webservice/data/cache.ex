defmodule WebService.Data.Cache do
  @moduledoc """
  Simple concurrent cities cache, based on a map.
  """
  use Agent

  @doc """
  Start listening for events.
  The first argument is irrelevant, and whatever is given
  will be discarded.
  """
  @spec start_link(any()) :: GenServer.on_start()
  def start_link(_) do
    Agent.start_link(fn -> Map.new() end, name: __MODULE__)
  end

  @doc """
  Fetch the information associated to the city passed
  as the only argument.
  If the city does not exist, a tuple indicating an
  error will be returned.
  """
  @spec fetch_city(String.t()) :: {:error, :not_found} | {:ok, {atom(), map()}}
  def fetch_city(key) do
    Agent.get(__MODULE__,  fn m ->
      case Map.get(m, key) do
        nil ->
          {:error, :not_found}
        value ->
          {:ok, value}
      end
    end)
  end

  @doc """
  Store the information of a city in the cache.
  """
  @spec put_city(String.t(), String.t()) :: :ok
  def put_city(key, value) do
    Agent.update(__MODULE__, fn m -> Map.put(m, key, value) end)
  end
end
