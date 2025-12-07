import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/result.{try}
import gleam/string
import input

type Range {
  Range(from: Int, to: Int)
}

type Kind {
  In
  Out
}

fn kind_index(k) {
  case k {
    In -> 0
    Out -> 1
  }
}

fn kind_compare(k1, k2) {
  int.compare(kind_index(k1), kind_index(k2))
}

type Event {
  Event(kind: Kind, at: Int)
}

fn walk_events(events: List(Event), start: Int, stack: Int, acc: Int) -> Int {
  case events {
    [] -> acc
    [Event(kind: In, at: x), ..rest] ->
      case stack {
        0 -> walk_events(rest, x, 1, acc)
        _ -> walk_events(rest, start, stack + 1, acc)
      }
    [Event(kind: Out, at: x), ..rest] ->
      case stack {
        1 -> walk_events(rest, -1, 0, acc + { x - start + 1 })
        _ -> walk_events(rest, start, stack - 1, acc)
      }
  }
}

pub fn solution() {
  use ls <- input.inputs(5)
  let assert #(ranges, [_, ..nums]) =
    list.split_while(ls, fn(s) { !string.is_empty(s) })
  let rangel =
    ranges
    |> list.try_map(fn(s) {
      use #(froms, tos) <- try(string.split_once(s, "-"))
      use from <- try(int.parse(froms))
      use to <- try(int.parse(tos))
      Ok(Range(from, to))
    })
    |> result.unwrap([])
  let numl = nums |> list.try_map(int.parse) |> result.unwrap([])

  io.println("<<<part1>>>")
  let res =
    numl
    |> list.filter(fn(x) {
      list.any(rangel, fn(r) { r.from <= x && x <= r.to })
    })
    |> list.length
  echo res

  io.println("<<<part2>>>")
  let events =
    rangel
    |> list.flat_map(fn(r) { [Event(In, r.from), Event(Out, r.to)] })
    |> list.sort(fn(e1, e2) {
      int.compare(e1.at, e2.at)
      |> order.break_tie(kind_compare(e1.kind, e2.kind))
    })

  let res2 = walk_events(events, 0, 0, 0)
  echo res2
}
