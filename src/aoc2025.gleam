import day3
import gleam/io

pub fn main() {
  case day3.solution() {
    Error(s) -> io.println(s)
    _ -> Nil
  }
}
