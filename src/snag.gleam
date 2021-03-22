import gleam/string_builder
import gleam/string
import gleam/list
import gleam/int

pub type Snag {
  Snag(issue: String, cause: List(String))
}

pub type Result(t) =
  Result(t, Snag)

pub fn new(issue: String) -> Snag {
  Snag(issue: issue, cause: [])
}

pub fn error(issue: String) -> Result(success) {
  Error(new(issue))
}

pub fn layer(snag: Snag, issue: String) -> Snag {
  Snag(issue: issue, cause: [snag.issue, ..snag.cause])
}

pub fn context(result: Result(success), issue: String) -> Result(success) {
  case result {
    Ok(_) -> result
    Error(snag) -> Error(layer(snag, issue))
  }
}

pub fn pretty_print(snag: Snag) -> String {
  let builder = string_builder.from_strings(["error: ", snag.issue, "\n"])

  string_builder.to_string(case snag.cause {
    [] -> builder
    cause ->
      builder
      |> string_builder.append("\ncause:\n")
      |> string_builder.append_builder(pretty_print_cause(cause))
  })
}

fn pretty_print_cause(cause) {
  cause
  |> list.index_map(fn(index, line) {
    string.concat(["  ", int.to_string(index), ": ", line, "\n"])
  })
  |> string_builder.from_strings
}

pub fn line_print(snag: Snag) -> String {
  [string.append("error: ", snag.issue), ..snag.cause]
  |> string.join(" <- ")
}
