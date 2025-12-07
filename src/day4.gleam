import aoc.{bool_to_int}
import gleam/dict
import gleam/io
import gleam/list
import gleam/pair
import gleam/string
import input

fn neighbors(i, j, d) {
  [
    #(i - 1, j - 1),
    #(i - 1, j),
    #(i - 1, j + 1),
    #(i, j - 1),
    #(i, j + 1),
    #(i + 1, j - 1),
    #(i + 1, j),
    #(i + 1, j + 1),
  ]
  |> list.filter(dict.has_key(d, _))
}

fn neighbors_cnt(i, j, d) {
  neighbors(i, j, d) |> list.length
}

fn remove_neighbors(n, d, q) {
  case n {
    [p, ..rest] -> {
      case dict.get(d, p) {
        Ok(4) -> remove_neighbors(rest, dict.delete(d, p), [p, ..q])
        Ok(v) -> remove_neighbors(rest, dict.insert(d, p, v - 1), q)
        _ -> panic as { "removing non-existing key" }
      }
    }
    [] -> #(d, q)
  }
}

fn access_iter(d, q, acc) {
  case q {
    [#(x, y), ..rest] -> {
      let #(d1, q1) = remove_neighbors(neighbors(x, y, d), d, rest)
      access_iter(d1, q1, acc + 1)
    }
    [] -> acc
  }
}

pub fn solution() {
  use ls <- input.inputs(4)
  //   use ls <- input.prefix_run(4, "sample")
  let ds =
    ls
    |> list.index_map(fn(row, i) {
      row
      |> string.to_graphemes
      |> list.index_map(fn(x, j) { #(#(i, j), x) })
      |> list.filter(fn(p) { pair.second(p) == "@" })
    })
    |> list.flatten
    |> dict.from_list

  io.println("part1:")

  let res1 =
    ds
    |> dict.fold(0, fn(acc, p, _) {
      let #(x, y) = p
      acc + bool_to_int(neighbors_cnt(x, y, ds) < 4)
    })
  echo res1

  io.println("part2:")

  let counts =
    ds
    |> dict.to_list
    |> list.map(fn(p) {
      let #(#(x, y) as k, _) = p
      #(k, neighbors_cnt(x, y, ds))
    })

  let q =
    counts |> list.filter(fn(p) { pair.second(p) < 4 }) |> list.map(pair.first)

  let d1 =
    q |> list.fold(dict.from_list(counts), fn(d, p) { dict.delete(d, p) })
  let res2 = access_iter(d1, q, 0)

  echo res2
}
