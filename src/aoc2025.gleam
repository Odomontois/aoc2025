import day7
import gleam/io

pub fn main() {
  case day7.solution() {
    Error(s) -> io.println(s)
    _ -> Nil
  }
}
