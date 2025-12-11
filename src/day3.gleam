import aoc
import gleam/int
import gleam/list
import gleam/order.{Eq, Gt, Lt}
import gleam/result
import gleam/string.{to_graphemes}
import input

fn str_max(s1: String, s2: String) {
  case string.compare(s1, s2) {
    Lt -> s2
    Gt | Eq -> s1
  }
}

fn joltage_iter(xs, acc) -> List(String) {
  case xs {
    [y, ..ys] -> {
      let prefixes = [y, ..{ list.take(acc, 11) |> list.map(fn(s) { s <> y }) }]
      let acc1 = case list.length(acc) < 12 {
        True -> list.append(acc, [""])
        False -> acc
      }
      let best = acc1 |> list.map2(prefixes, str_max)
      joltage_iter(ys, best)
    }
    [] -> acc
  }
}

fn max_joltage(s) {
  let ls = to_graphemes(s)
  joltage_iter(ls, [])
}

pub fn at(l, ix, default) {
  l |> list.drop(ix) |> list.first |> result.unwrap(default)
}

pub fn sum_best(l, ix) {
  l
  |> list.map(at(_, ix, ""))
  |> list.try_map(int.parse)
  |> result.unwrap([])
  |> aoc.sum
}

pub fn solution() {
  use in, _ <- input.lines(3)
  let xs = in |> list.map(max_joltage)
  echo xs |> sum_best(1)
  echo xs |> sum_best(11)
  //   echo aolist.sum(xs)
  aoc.done
}
