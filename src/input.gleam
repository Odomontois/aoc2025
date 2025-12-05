import gleam/int
import gleam/io
import gleam/result.{try}
import gleam/string
import simplifile.{type FileError}

pub fn read_lines(num, sort) -> Result(List(String), FileError) {
  let filename = "./input/day" <> int.to_string(num) <> "." <> sort
  use content <- try(simplifile.read(filename))
  Ok(string.split(content, "\n"))
}

fn prefix_run(num, sort, fun) -> Result(a, FileError) {
  use lines <- try(read_lines(num, "sample"))
  io.println("===[" <> sort <> "]===\n")
  fun(lines)
}

pub fn inputs(num, fun) -> Result(a, FileError) {
  use _ <- try(prefix_run(num, "sample", fun))
  prefix_run(num, "full", fun)
}
