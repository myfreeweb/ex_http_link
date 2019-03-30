[![hex.pm version](https://img.shields.io/hexpm/v/ex_http_link.svg?style=flat)](https://hex.pm/packages/ex_http_link)
[![hex.pm downloads](https://img.shields.io/hexpm/dt/ex_http_link.svg?style=flat)](https://hex.pm/packages/ex_http_link)
[![API Docs](https://img.shields.io/badge/api-docs-yellow.svg?style=flat)](https://hexdocs.pm/ex_http_link/)
[![unlicense](https://img.shields.io/badge/un-license-green.svg?style=flat)](http://unlicense.org)

# ex_http_link

From the creator or [HTTPotion] and [a Haskell version of this](https://github.com/myfreeweb/http-link-header)...

An [Elixir] library than implements a parser (TODO: and a writer) for the HTTP Link header as specified in [RFC 5988 "Web Linking"](https://tools.ietf.org/html/rfc5988).

Why this when [ex_link_header] exists? This one uses awesome [NimbleParsec] parser combinators instead of messy regexps and [doesn't turn arbitrary strings into atoms](https://engineering.klarna.com/monitoring-erlang-atoms-c1d6a741328e).

[Elixir]: https://elixir-lang.org
[HTTPotion]: https://github.com/myfreeweb/httpotion
[ex_link_header]: https://github.com/simonrand/ex_link_header
[NimbleParsec]: https://github.com/plataformatec/nimble_parsec

## Installation

Add ex_http_link to your project's dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_http_link, "~> 0.1.0"}
  ]
end
```

And fetch your project's dependencies:

```shell
$ mix deps.get
```

## Usage

```elixir
iex> ExHttpLink.parse ~S(<http://example.com>; rel="example"; rev=test, <yolo.swag>; whatEver="")
{:ok, [ { "http://example.com", {"rel", "example"}, {"rev", "test"} },
        { "yolo.swag", {"whatEver", ""} } ]}
```

## Contributing

Please feel free to submit pull requests!

By participating in this project you agree to follow the [Contributor Code of Conduct](https://contributor-covenant.org/version/1/4/).

[The list of contributors is available on GitHub](https://github.com/myfreeweb/ex_http_link/graphs/contributors).

## License

This is free and unencumbered software released into the public domain.  
For more information, please refer to the `UNLICENSE` file or [unlicense.org](https://unlicense.org).
