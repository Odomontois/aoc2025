import gleam/list

pub fn sum(xs) {
  list.fold(xs, 0, fn(a, b) { a + b })
}

pub fn bool_to_int(x) {
  case x {
    True -> 1
    False -> 0
  }
}
