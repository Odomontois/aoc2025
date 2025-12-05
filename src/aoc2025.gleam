import day5
import gleam/io

pub fn main() {
  case day5.solution() {
    Error(s) -> io.println(s)
    _ -> Nil
  }
}
