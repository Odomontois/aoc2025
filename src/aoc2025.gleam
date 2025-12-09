import day9
import gleam/io

pub fn main() {
  case day9.solution() {
    Error(s) -> io.println(s)
    _ -> Nil
  }
}
