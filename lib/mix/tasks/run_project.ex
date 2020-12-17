defmodule Mix.Tasks.RunProject do
  use Mix.Task

  @shortdoc "Simply calls the WebService.main/0 function."
  def run(_) do
    Mix.Task.run("app.start")

    WebService.main()
  end
end

