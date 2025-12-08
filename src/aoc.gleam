import gleam/int
import gleam/list
import gleam/result

pub fn sum(xs) {
  list.fold(xs, 0, fn(a, b) { a + b })
}

pub fn bool_to_int(x) {
  case x {
    True -> 1
    False -> 0
  }
}

pub fn parse_int(s) {
  int.parse(s) |> result.replace_error("Can't parse " <> s <> " as int")
}

pub fn on(f, proj) {
  fn(x, y) { f(proj(x), proj(y)) }
}

pub const done = Ok(Nil)

pub const skip = Error(Nil)
