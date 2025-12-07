import aoc.{bool_to_int}
import fp/func
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import input

fn splitter(
  line: List(#(String, Int)),
  p1: Int,
  p2: Int,
  res: List(Int),
  splits: Int,
) -> Result {
  let res1 = [p1, ..res]
  case line {
    [] -> Result(list.reverse(res1) |> list.drop(1), splits)
    [g, ..rest] ->
      case g {
        #("S", _) -> splitter(rest, 1, 0, res1, splits)
        #("^", x) ->
          splitter(rest, p2, x, [p1 + x, ..res], splits + bool_to_int(x > 0))
        #(_, x) -> splitter(rest, p2 + x, 0, [p1, ..res], splits)
      }
  }
}

type Result {
  Result(line: List(Int), count: Int)
}

fn splitters_show(b, c) {
  case b, c {
    x, "." if x > 0 -> "|"
    _, c -> c
  }
}

fn splitters(ls) {
  let init =
    list.first(ls)
    |> result.unwrap("")
    |> string.to_graphemes
    |> list.map(func.constant(0))
    |> Result(0)
  list.fold(ls, init, fn(p, l) {
    let Result(line, splits) = p
    let l1 = string.to_graphemes(l)
    splitter(list.zip(l1, line), 0, 0, [], splits)
    |> func.tap(fn(res) { res.line |> list.map2(l1, splitters_show) |> echo })
  })
}

pub fn solution() {
  use ls <- input.inputs(7)
  splitters(ls) |> echo |> fn(x) { x.line } |> int.sum |> echo
}
