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

pub fn prefix_run(num, sort, fun) -> Result(a, String) {
  use lines <- try(read_lines(num, sort))
  io.println("===[" <> sort <> "]===\n")
  Ok(fun(lines |> remove_last_empty))
}

pub fn inputs(num, fun) -> Result(a, String) {
  use _ <- try(prefix_run(num, "sample", fun))
  prefix_run(num, "full", fun)
}

pub fn sample_input(num, fun) -> Result(a, String) {
  prefix_run(num, "sample", fun)
}
