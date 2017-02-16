defmodule Whoami.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    conn
    |> send_resp(200, Whoami.parse_conn(conn))
  end

  match _ do
    conn
    |> send_resp(404, "This is not the page you are looking for.")
  end

  def start_link do
    {:ok, _} = Plug.Adapters.Cowboy.http(Whoami.Router, [], port: get_port())
  end

  defp get_port() do
    port_env_variable = System.get_env("PORT")
    if port_env_variable do
      String.to_integer(port_env_variable)
    else
      4000
    end
  end
end
