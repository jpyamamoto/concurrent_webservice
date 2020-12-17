defmodule WebService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {WebService.Data.Cache, []},
    ]

    opts = [strategy: :one_for_one, name: WebService.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
