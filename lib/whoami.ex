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
    cl = String.to_charlist(s)
    first_opening = Enum.find_index(cl, fn(x) -> x == 40 end)
    sub_cl = Enum.slice(cl, (first_opening+1)..-1)
    content = Enum.reduce_while(sub_cl, {[], 1}, fn(x, {list, counter} = acc) ->
                        if counter < 1 do
                          {:halt, acc}
                        else 
                          case x do
                            40 -> {:cont, {[x | list], counter + 1}}
                            41 -> {:cont, {[x | list], counter - 1}}
                            _ -> {:cont, {[x | list], counter}}
                          end
                        end
    end)

    content
    |> elem(0)
    |> Enum.slice(1..-1)
    |> Enum.reverse()
    |> List.to_string()
  end
end
