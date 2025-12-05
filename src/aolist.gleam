import gleam/list

pub fn sum(xs) {
  list.fold(xs, 0, fn(a, b) { a + b })
}
