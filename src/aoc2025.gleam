import day10
import gleam/io

pub fn main() {
  case day10.solution() {
    Error(s) -> io.println(s)
    _ -> Nil
  }
}
