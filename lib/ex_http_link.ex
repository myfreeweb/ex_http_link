defmodule ExHttpLink do
  @moduledoc """
  Library for the HTTP Link header as specified in [RFC 5988 "Web Linking"](https://tools.ietf.org/html/rfc5988).
  """

  import NimbleParsec

  skip_space = ignore(ascii_char([?\s, ?\t, ?\r, ?\n]))

  normal_value =
    ignore(ascii_char([?"]))
    |> choice([
      repeat(
        choice([
          utf8_string([not: ?\\, not: ?"], min: 1) |> map({URI, :decode, []}),
          ignore(string("\\")) |> ascii_char([]) |> reduce({List, :to_string, []})
        ])
      )
      |> reduce({Enum, :join, []}),
      string("")
    ])
    |> ignore(ascii_char([?"]))
    |> label("normal value")

  rel_rev_value =
    choice([
      normal_value,
      utf8_string([?-, ?0..?9, ?a..?z, ?A..?Z, ?.], min: 1)
    ])

  title_star_value =
    choice([
      utf8_string([not: ?\s, not: ?\t, not: ?\r, not: ?\n], min: 1),
      string("")
    ])

  attr =
    repeat(skip_space)
    |> ignore(ascii_char([?;]))
    |> repeat(skip_space)
    |> choice([
      string("rel")
      |> repeat(skip_space)
      |> ignore(ascii_char([?=]))
      |> repeat(skip_space)
      |> concat(rel_rev_value),
      string("rev")
      |> repeat(skip_space)
      |> ignore(ascii_char([?=]))
      |> repeat(skip_space)
      |> concat(rel_rev_value),
      string("title*")
      |> repeat(skip_space)
      |> ignore(ascii_char([?=]))
      |> repeat(skip_space)
      |> concat(title_star_value),
      utf8_string([not: ?=, not: ?\s, not: ?\t, not: ?\r, not: ?\n], min: 1)
      |> repeat(skip_space)
      |> ignore(ascii_char([?=]))
      |> repeat(skip_space)
      |> concat(normal_value)
    ])
    |> reduce({List, :to_tuple, []})

  link =
    repeat(skip_space)
    |> ignore(ascii_char([?<]))
    |> repeat(skip_space)
    |> utf8_string([not: ?>, not: ?\s, not: ?\t, not: ?\r, not: ?\n], min: 1)
    |> repeat(skip_space)
    |> ignore(ascii_char([?>]))
    |> times(attr, min: 1)
    |> reduce({List, :to_tuple, []})

  defparsec :links_parsec,
            times(link |> optional(ignore(ascii_char([?,])) |> concat(repeat(skip_space))), min: 1)

  @doc """
  Parse a Link header.

  ## Examples

      iex> ExHttpLink.parse ~S(<http://example.com>; rel="example"; rev=test)
      {:ok, [ { "http://example.com", {"rel", "example"}, {"rev", "test"} } ]}

      iex> ExHttpLink.parse ~S(<yolo.swag>; whatEver="", <http://dev/null>; rel=next)
      {:ok, [ { "yolo.swag", {"whatEver", ""} }, { "http://dev/null", {"rel", "next"} } ]}

      iex> ExHttpLink.parse ~S(<yolo.swag>; title="some \\" thing \\" %22stuff%22 ")
      {:ok, [ { "yolo.swag", {"title", "some \\" thing \\" \\"stuff\\" "} } ]}

      iex> ExHttpLink.parse ~S(\t\t   < http://example.com\t>;rel=\t"example";   \ttitle ="example dot com" \t )
      {:ok, [ { "http://example.com", {"rel", "example"}, {"title", "example dot com"} } ]}

      iex> ExHttpLink.parse ~S(<wat>; title*=UTF-8'de'n%c3%a4chstes%20Kapitel)
      {:ok, [ { "wat", {"title*", "UTF-8'de'n%c3%a4chstes%20Kapitel"}  } ]}
  """
  def parse(header) do
    case links_parsec(header) do
      {:ok, result, _, _, _, _} -> {:ok, result}
      x -> x
    end
  end
end
