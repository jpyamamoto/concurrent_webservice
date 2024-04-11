defmodule WebService do
  @moduledoc """
  Main module, with entry point to the program.
  """

  alias WebService.Parsing

  @files [
    "dataset1.csv",
    "dataset2.csv",
  ]
  @timeout 60_000

  @doc """
  Entry point to the program.
  """
  def main do
    [first | rest] = @files
    process_file(first)

    Enum.each(rest, fn file ->
      IO.puts("Deteniendo ejecución por #{@timeout / 1_000} segundos...")
      Process.sleep(@timeout)
      process_file(file)
    end)
  end

  defp process_file(file) do
    IO.puts("Procesando archivo #{file}.")

    tickets =
      Application.app_dir(:webservice, "priv")
      |> Path.join(file)
      |> File.stream!()
      |> Parsing.csv_to_map()
      |> Stream.map(&Parsing.parse_line/1)
      |> Stream.map(&Parsing.use_iata_codes/1)

    tickets
    |> Stream.flat_map(fn {origin, dest} -> [origin, dest] end)
    |> Stream.uniq()
    |> WebService.Data.populate()

    WebService.Ticket.process(tickets)

    IO.puts("Finalizó el procesamiento del archivo #{file}.")
  end
end
