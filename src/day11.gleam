import aoc
import gleam/dict
import gleam/list
import gleam/result.{replace_error, try}
import gleam/string.{split_once}
import input

fn parse_line(s) {
  use #(from, to) <- try(split_once(s, ": ") |> replace_error("bad line" <> s))
  let tos = string.split(to, " ")
  #(from, tos) |> Ok
}

type Graph {
  Graph(adj: dict.Dict(String, List(String)))
}

fn graph(lines) {
  //   let inbound = {
  //     use g1, #(_, outs) <- list.fold(lines, dict.new())
  //     use g2, num <- list.fold(outs, g1)
  //     dict.upsert(g2, num, fn(o) { option.unwrap(o, 0) + 1 })
  //   }
  Graph(dict.from_list(lines))
}

fn walk_neighbors(cache, g: Graph, ns, end) {
  let #(res, cache) =
    list.fold(ns, #(0, cache), fn(s, n) {
      let #(acc, cache) = s
      let #(v, cache) = walk(cache, g, n, end)
      #(acc + v, cache)
    })
  #(res, cache)
}

fn walk(cache, g: Graph, start, end) {
  case start == end {
    True -> #(1, cache)
    False ->
      case dict.get(cache, start) {
        Ok(v) -> #(v, cache)
        _ ->
          case dict.get(g.adj, start) {
            Error(_) -> #(0, cache)
            Ok(ns) -> {
              let #(res, cache) = walk_neighbors(cache, g, ns, end)
              let cache = dict.insert(cache, start, res)
              #(res, cache)
            }
          }
      }
  }
}

pub fn solution() {
  use ls, _ <- input.lines(11)
  use inps <- try(ls |> list.try_map(parse_line))
  let g = graph(inps)
  //   echo g
  let #(res, _) = walk(dict.new(), g, "you", "out")
  echo res

  aoc.done
}
