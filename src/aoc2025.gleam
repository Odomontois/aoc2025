import argv
import clip.{type Command}
import clip/arg
import clip/opt.{type Opt}
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
import gleam/result.{try}
import input.{type Sort}

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

fn day_opt() -> Opt(Int) {
  opt.new("day") |> opt.int |> opt.help("The AOC day") |> opt.default(today)
}

fn sort_arg() -> arg.Arg(Sort) {
  arg.new("sort")
  |> arg.try_map(input.sort_parse)
  |> arg.help("The input sort")
}

fn command() -> Command(#(Int, List(Sort))) {
  clip.command({
    use day <- clip.parameter
    use sorts <- clip.parameter
    #(day, sorts)
  })
  |> clip.opt(day_opt())
  |> clip.arg_many(sort_arg())
}

const today = 11

pub fn main() {
  let parsed_command = command() |> clip.run(argv.load().arguments)

  let run_result = {
    use #(day, sorts) <- try(parsed_command)
    let ss = case sorts {
      [] -> [input.Sample, input.Full]
      _ -> sorts
    }

    let solution =
      solutions
      |> list.drop(day - 1)
      |> list.first
      |> result.unwrap(dummy_solution(day))

    solution()(ss)
  }
  case run_result {
    Error(s) -> io.println(s)
    _ -> Nil
  }
}
