import snag.{Snag}
import gleam/should

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
