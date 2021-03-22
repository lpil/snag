import snag
import gleam/should

pub fn hello_world_test() {
  snag.hello_world()
  |> should.equal("Hello, from snag!")
}
