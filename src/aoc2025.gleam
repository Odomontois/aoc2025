import day8
import gleam/io

pub fn main() {
  case day8.solution() {
    Error(s) -> io.println(s)
    _ -> Nil
  }
}
