import gleeunit
import gleeunit/should
import snag.{Snag}

pub fn main() {
  gleeunit.main()
}

pub fn context_test() {
  Ok(1)
  |> snag.context("oh no")
  |> should.equal(Ok(1))

  snag.error("Could not open file")
  |> snag.context("Save failed")
  |> should.equal(Error(Snag("Save failed", ["Could not open file"])))
}

pub fn pretty_print_test() {
  snag.new("Directory not writable")
  |> snag.layer("Could not open file")
  |> snag.layer("Save failed")
  |> snag.pretty_print
  |> should.equal(
    "error: Save failed

cause:
  0: Could not open file
  1: Directory not writable
",
  )
}

pub fn line_print_test() {
  snag.new("Directory not writable")
  |> snag.layer("Could not open file")
  |> snag.layer("Save failed")
  |> snag.line_print
  |> should.equal(
    "error: Save failed <- Could not open file <- Directory not writable",
  )
}

pub fn map_error_error_test() {
  let describe_error = fn(_) -> String { "Error #1" }

  Error(1)
  |> snag.map_error(describe_error)
  |> snag.context("Could not open file")
  |> should.equal(Error(Snag("Could not open file", ["Error #1"])))
}

pub fn map_error_ok_test() {
  let describe_error = fn(_) -> String { "Error #1" }

  Ok(0)
  |> snag.map_error(describe_error)
  |> snag.context("Could not open file")
  |> should.equal(Ok(0))
}
