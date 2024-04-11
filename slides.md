---
theme: gaia
_class: lead
paginate: true
backgroundColor: #fff
backgroundImage: url('https://marp.app/assets/hero-background.svg')
marp: true
---

![bg left:35% 80%](https://cdn.icon-icons.com/icons2/2699/PNG/512/elixir_lang_logo_icon_169207.png)

# **Airport Weather Queries**

Juan Pablo Yamamoto

[GitHub](https://github.com/jpyamamoto/concurrent_webservice)

---

# Situation

We've been tasked to implement a service to gather information on the weather at several airports given the plane tickets of the passengers.

---

# Features
- Parsing of non-standardized data
- Parallel queries
- Cache results

---

# Solution

---

# Solution

![bg center-bottom:80% 50%](https://cdn.icon-icons.com/icons2/2699/PNG/512/elixir_lang_logo_icon_170184.png)

---

# Highlights

## Structs

```elixir
defmodule WebService.Airport do
  @type t() :: %__MODULE__{
    name: String.t() | nil,
    lat: number() | nil,
    lon: number() | nil,
    iata: String.t() | nil
  }

  defstruct [:name, :lon, :lat, :iata]
end
```

---

## Structs

```elixir
defmodule WebService.Weather do
  @type t() :: %__MODULE__{
    temp: number(),
    temp_min: number(),
    temp_max: number(),
    humidity: number(),
    lat: number(),
    lon: number(),
    name: String.t()
  }

  @enforce_keys [:temp, :temp_min, :temp_max, :humidity, :lat, :lon, :name]
  defstruct [:temp, :temp_min, :temp_max, :humidity, :lat, :lon, :name]
end
```

---

## Structs

```elixir
defmodule WebService.Ticket do
  @type t() :: %__MODULE__{
    origin: Airport.t(),
    destination: Airport.t()
  }

  @enforce_keys [:origin, :destination]
  defstruct [:origin, :destination]
end
```

---

## Environment Variables

```elixir
# config/runtime.exs
import Config
import Dotenvy

source!([".env", System.get_env()])

config :webservice,
  openweather_appid: env!("OPENWEATHER_APPID", :string!)
```

```elixir
# lib/utils.ex
def get_appid(), do: Application.fetch_env!(:webservice, :openweather_appid)
def get_timeframe(), do: Application.fetch_env!(:webservice, :timeframe)
def get_max_requests(), do: Application.fetch_env!(:webservice, :max_requests)
```

---

# Meta-Programming
(Not really the best decision, but something to flex nonetheless)

```elixir
@external_resource
|> File.stream!()
|> CSV.decode(headers: true)
|> ...
|> Enum.each(fn %{"iata_code" => iata, "name" => name, "lat" => lat, "lon" => lon} ->
  def airport_from_iata(unquote(iata)) do
    %__MODULE__{name: unquote(name), iata: unquote(iata), lat: unquote(lat), lon: unquote(lon)}
  end
end)

def airport_from_iata(_), do: nil
```

---

# Mock Testing

```elixir
test "failed request: 400" do
  with_mock HTTPoison,
    [get: fn(_) ->
        {:ok, %HTTPoison.Response{status_code: 400, body: "Not found"}} end
    ] do
    assert WebService.Data.API.by_name("Invalid") == {:error, :not_found}
  end
end
```

---

# Mock Testing

```elixir
test "prints info correctly" do
  with_mocks([
    {Stream, [], [
      run: fn x -> Enum.to_list(x) |> Enum.join("\n") end,
      map: &Enum.map/2
      ]},
    {IO, [], [puts: fn(str) -> str end]},
    {WebService.Data, [], [
      fetch_city: fn (%Airport{name: name, lon: lon, lat: lat} = airport) -> 
        {:ok, %Weather{@fake_weather | name: name, lon: lon, lat: lat}, airport} end
      ]}
    ]) do
    assert WebService.Ticket.process([{@airport1, @airport2}]) == expected_string
  end
end
```

---

# What did I learn?

* A couple libraries:
  * [Mock](https://hexdocs.pm/mock/Mock.html)
  * [Dotenvy](https://hexdocs.pm/dotenvy/readme.html)
  * [HTTPoison](https://hexdocs.pm/httpoison/HTTPoison.html)
  * [Dialixyr](https://hexdocs.pm/dialyxir/readme.html)

---

# What did I learn?

* Embrace modularity
  * Low coupling
  * High cohesion
  * Keep user interaction/effects only on the frontier modules

---

# What did I learn?

* **Types!**
  * Use `struct`s to model your business components
  * Clarity
  * Get pattern matching for free
  * Use [`dialyxir`](https://hexdocs.pm/dialyxir/readme.html):
    ```sh
    > mix dialyzer
    Total errors: 0, Skipped: 0, Unnecessary Skips: 0
    done in 0m5.26s
    done (passed successfully)
    ```

---

# Future improvements

* A better architecture
* Consider using Erlang's [`ets`](https://www.erlang.org/doc/man/ets.html)
* A better rate-limiting mechanism for API queries
* Rethink the proper use of asynchrounous tasks

---

<!-- _class: lead -->

![bg left:35% 80%](https://cdn.icon-icons.com/icons2/2699/PNG/512/elixir_lang_logo_icon_169207.png)

# **Airport Weather Queries**

Juan Pablo Yamamoto

[GitHub](https://github.com/jpyamamoto/concurrent_webservice)