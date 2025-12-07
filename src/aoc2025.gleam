import day6
import gleam/io

pub fn main() {
  case day6.solution() {
    Error(s) -> io.println(s)
    _ -> Nil
  }
}
