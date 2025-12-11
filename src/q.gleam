import gleam/list

pub type Queue(a) {
  Queue(front: List(a), back: List(a))
}

pub fn empty() -> Queue(a) {
  Queue([], [])
}

pub fn push(q: Queue(a), v: a) -> Queue(a) {
  Queue(..q, back: [v, ..q.back])
}

pub fn pop(q: Queue(a)) -> Result(#(a, Queue(a)), Nil) {
  case q.front {
    [f, ..rest] -> Ok(#(f, Queue(..q, front: rest)))
    [] ->
      case list.reverse(q.back) {
        [] -> Error(Nil)
        [f, ..rest] -> Ok(#(f, Queue(rest, [])))
      }
  }
}
