import aoc
import gleam/list
import gleam/result.{replace_error, try}
import gleam/string.{split_once}
import input

fn parse_line(s) {
  use #(from, to) <- try(split_once(s, ": ") |> replace_error("bad line" <> s))
  let tos = string.split(to, " ")
  #(from, tos) |> Ok
}

pub fn solution() {
  use ls, _ <- input.lines(11)
  use inps <- try(ls |> list.try_map(parse_line))
  echo inps

  aoc.done
}
