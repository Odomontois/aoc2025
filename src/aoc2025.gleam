import day4
import gleam/io

pub fn main() {
  case day4.solution() {
    Error(s) -> io.println(s)
    _ -> Nil
  }
}
