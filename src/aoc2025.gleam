import day1
import day10
import day11
import day2
import day3
import day4
import day5
import day6
import day7
import day8
import day9
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import input

const solutions = [
  day1.solution,
  day2.solution,
  day3.solution,
  day4.solution,
  day5.solution,
  day6.solution,
  day7.solution,
  day8.solution,
  day9.solution,
  day10.solution,
  day11.solution,
]

fn dummy_solution(day) {
  fn() {
    fn(_sorts) {
      echo "No solution for day " <> int.to_string(day + 1)
      Ok([])
    }
  }
}

pub fn main() {
  let day = 11
  let sorts = [input.Full, input.Sample]

  let solution =
    solutions
    |> list.drop(day - 1)
    |> list.first
    |> result.unwrap(dummy_solution(day))

  case solution()(sorts) {
    Error(s) -> io.println(s)
    _ -> Nil
  }
}
