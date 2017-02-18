defmodule Whoami do
  @moduledoc """
  Documentation for Whoami.
  """

  def parse_conn(conn) do
    ip_address = parse_ip_address(conn)
    language = parse_language(conn)
    software = parse_software_info(conn)
    ~s({"ipaddress":"#{ip_address}","language":"#{language}","software":"#{software}"})
  end
   
  defp parse_ip_address(conn) do
    conn.remote_ip
    |> Tuple.to_list()
    |> Enum.join(".")
  end

  defp parse_language(conn) do
    conn.req_headers
    |> Enum.find(fn({key, _}) -> key == "accept-language" end)
    |> elem(1)
    |> String.split(",")
    |> List.first()
  end

  defp parse_software_info(conn) do
    conn.req_headers
    |> Enum.find(fn({key, _}) -> key == "user-agent" end)
    |> elem(1)
    |> get_content_of_first_pair_of_parentheses()
  end

  defp get_content_of_first_pair_of_parentheses(s) do
    subs = substring_after_first_opening_paren(s)

    length_after_first_opening_paren = byte_size(subs)

    length_after_matching_closing_paren =
      subs
      |> substring_after_matching_closing_paren(0)
      |> byte_size()

    binary_part(subs, 0, length_after_first_opening_paren - length_after_matching_closing_paren)
  end

  defp substring_after_first_opening_paren(<<"(", rest::binary>>), do: rest
  defp substring_after_first_opening_paren(<<_, rest::binary>>), do: substring_after_first_opening_paren(rest)

  defp substring_after_matching_closing_paren(<<")", _::binary>> = rest, 0), do: rest
  defp substring_after_matching_closing_paren(<<")", rest::binary>>, n), do: substring_after_matching_closing_paren(rest, n - 1)
  defp substring_after_matching_closing_paren(<<"(", rest::binary>>, n), do: substring_after_matching_closing_paren(rest, n + 1)
  defp substring_after_matching_closing_paren(<<_::utf8, rest::binary>>, n), do: substring_after_matching_closing_paren(rest, n)
end
