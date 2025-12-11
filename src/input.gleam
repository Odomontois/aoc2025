import gleam/int
import gleam/io
import gleam/list
import gleam/result.{try}
import gleam/string
import simplifile

pub fn read_lines(num, sort) -> Result(List(String), String) {
  let filename = "./input/day" <> int.to_string(num) <> "." <> sort
  use content <- try(
    result.map_error(simplifile.read(filename), fn(e) {
      simplifile.describe_error(e) <> ":" <> filename
    }),
  )
  Ok(string.split(content, "\n"))
}

fn remove_last_empty(lines) {
  case list.reverse(lines) {
    ["", ..rest] -> list.reverse(rest)
    _ -> lines
  }
}

pub type Sort {
  Full
  Sample
}

fn sort_to_string(s) {
  case s {
    Full -> "full"
    Sample -> "sample"
  }
}

pub fn prefix_run(num, sort, fun) -> Result(a, String) {
  let sort_s = sort_to_string(sort)
  use lines <- try(read_lines(num, sort_s))
  io.println("===[" <> sort_s <> "]===\n")
  fun(lines |> remove_last_empty, sort)
}

pub fn tagged_inputs(num, fun, sorts) -> Result(List(a), String) {
  sorts |> list.try_map(prefix_run(num, _, fun))
}

pub fn lines(num, fun) -> fn(List(Sort)) -> Result(List(a), String) {
  tagged_inputs(num, fun, _)
}
