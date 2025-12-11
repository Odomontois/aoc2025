import aoc
import gleam/int
import gleam/list
import gleam/result
import gleam/string.{split}
import input

type Range {
  Range(from: Int, to: Int)
}

fn sum_range(
  start: Int,
  end: Int,
  acc: Int,
  trans: fn(Int) -> Int,
  pred: fn(Int) -> Bool,
) -> Int {
  case start > end {
    True -> acc
    False -> {
      let x = trans(start)
      let next = case pred(x) {
        True -> {
          echo x
          acc + x
        }
        False -> acc
      }
      sum_range(start + 1, end, next, trans, pred)
    }
  }
}

fn times_count(x: Int, base: Int, count: Int) -> Int {
  case count {
    1 -> x
    _ -> times_count(x, base, count - 1) * base + x
  }
}

fn times_compare(x: Int, base: Int, count: Int) -> Int {
  case x < base {
    True -> times_count(x, base, count)
    False -> times_compare(x, base * 10, count)
  }
}

fn times(count: Int) -> fn(Int) -> Int {
  fn(x) { times_compare(x, 10, count) }
}

pub fn solution() {
  use ls, _ <- input.lines(2)
  let ranges =
    string.join(ls, "")
    |> split(",")
    |> list.map(fn(s) {
      case split(s, "-") |> list.try_map(int.parse) {
        Ok([l, r]) -> Range(l, r)
        _ -> panic as "expected two numbers"
      }
    })

  let in_ranges = fn(x: Int) {
    list.any(ranges, fn(r) { r.from <= x && x <= r.to })
  }
  let result = fn(top, count) { sum_range(0, top, 0, times(count), in_ranges) }
  let res = [
    result(100_000, 2),
    result(1000, 3),
    // result(100, 4),
    result(100, 5),
    -result(10, 6),
    result(10, 7),
    //result(10, 8),
    //result(10, 9),
    -result(10, 10),
  ]
  echo ranges
  echo res
  echo res |> list.first |> result.unwrap(0)
  echo res |> list.fold(0, fn(x, y) { x + y })
  aoc.done
}
