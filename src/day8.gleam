import aoc.{done, on, skip}
import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list.{try_map}
import gleam/pair
import gleam/result.{try}
import gleam/string
import input
import uf.{Root}

fn size(t) {
  case t {
    input.Full -> 1000
    input.Sample -> 10
  }
}

type Point {
  Point(x: Int, y: Int, z: Int)
}

fn sq(p) {
  p * p
}

fn dist2(p1: Point, p2: Point) {
  sq(p1.x - p2.x) + sq(p1.y - p2.y) + sq(p1.z - p2.z)
}

fn parse(s: String) -> Result(Point, String) {
  case string.split(s, ",") |> list.try_map(int.parse) {
    Ok([x, y, z]) -> Ok(Point(x, y, z))
    _ -> Error("expecting three numeric components, got " <> s)
  }
}

fn merge_dist(uf, d) {
  let #(#(i, j), _) = d
  uf.merge(uf, i, j)
}

fn iter_merge(uf, dists, size) {
  case dists {
    [] -> []
    [#(#(i, j), _), ..rest] -> {
      let uf1 = uf.merge(uf, i, j)
      case uf.root_size(uf1, i) == size {
        True -> [i, j]
        False -> iter_merge(uf1, rest, size)
      }
    }
  }
}

pub fn solution() {
  use ls, sort <- input.try_inputs(8)
  use ps <- try(try_map(ls, parse))
  let indexed = ps |> list.index_map(pair.new)
  let dists =
    {
      use #(p1, i) <- list.flat_map(indexed)
      use #(p2, j) <- list.map(indexed |> list.drop(i + 1))
      #(#(i, j), dist2(p1, p2))
    }
    |> list.sort(int.compare |> on(pair.second))

  let count = list.length(ps)
  let init = uf.of_size(count)

  io.println("[[part1]]")
  let part1 =
    dists
    |> list.take(size(sort))
    |> list.fold(init, merge_dist)
    |> dict.values
    |> list.filter_map(fn(x) {
      case x {
        Root(i) if i > 1 -> Ok(i)
        _ -> skip
      }
    })
    |> list.sort(int.compare)
    |> list.reverse
    |> list.take(3)
    |> echo
    |> int.product
    |> echo

  io.println("[[part2]]")

  iter_merge(init, dists, count)
  |> echo
  |> list.try_map(fn(i) { list.drop(ps, i) |> list.first })
  |> result.unwrap([])
  |> echo
  |> list.map(fn(p) { p.x })
  |> int.product
  |> echo

  done
}
