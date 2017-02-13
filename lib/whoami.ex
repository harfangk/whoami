defmodule Whoami do
  @moduledoc """
  Documentation for Whoami.
  """

  def parse_conn(conn) do
    conn.req_headers
  end
  #[{"host", "localhost:4000"}, {"connection", "keep-alive"}, {"upgrade-insecure-requests", "1"}, {"user-agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36"}, {"accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"}, {"accept-encoding", "gzip, deflate, sdch, br"}, {"accept-language", "ko-KR,ko;q=0.8,en-US;q=0.6,en;q=0.4"}]
   
  defp parse_ip_address(conn) do
    conn.remote_ip
    |> Tuple.to_list()
    |> Enum.join(".")
  end

  defp parse_language(conn) do
    conn.req_headers
  end
end
