import aoc
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/result.{try}
import input
import nibble.{do, replace, return, token}
import nibble/lexer

type Token {
  SquareOpen
  SquareClose
  ParensOpen
  ParensClose
  BraceOpen
  BraceClose
  Comma
  Number(value: Int)
  Hash
  Dot
}

type Entry {
  Entry(bits: Int, switches: List(Int), ends: List(Int))
}

fn parser() {
  let lexer =
    lexer.simple([
      lexer.int(Number),
      lexer.token("(", ParensOpen),
      lexer.token(")", ParensClose),
      lexer.token("[", SquareOpen),
      lexer.token("]", SquareClose),
      lexer.token("{", BraceOpen),
      lexer.token("}", BraceClose),
      lexer.token(",", Comma),
      lexer.token("#", Hash),
      lexer.token(".", Dot),
      lexer.whitespace(Nil) |> lexer.ignore,
    ])

  let symbol =
    nibble.one_of([token(Hash) |> replace(1), nibble.token(Dot) |> replace(0)])

  let initial = {
    use _ <- do(token(SquareOpen))
    use xs <- do(nibble.many1(symbol))
    use _ <- do(token(SquareClose))
    xs |> list.reverse |> list.fold(0, fn(x, b) { x * 2 + b }) |> return
  }

  let int = {
    use tok <- nibble.take_map("expected number")
    case tok {
      Number(v) -> Some(v)
      _ -> None
    }
  }

  let ints = nibble.sequence(int, token(Comma))

  let switch = {
    use _ <- do(token(ParensOpen))
    use nums <- do(ints)
    use _ <- do(token(ParensClose))
    nums
    |> list.fold(0, fn(x, dig) {
      int.bitwise_shift_left(1, dig) |> int.bitwise_or(x)
    })
    |> return
  }

  let ending = {
    use _ <- do(token(BraceOpen))
    use nums <- do(ints)
    use _ <- do(token(BraceClose))
    return(nums)
  }

  let result = {
    use bits <- do(initial)
    use switches <- do(nibble.many(switch))
    use ends <- do(ending)
    return(Entry(bits, switches, ends))
  }

  fn(l) {
    use ls <- try(lexer.run(l, lexer) |> aoc.err_string)
    nibble.run(ls, result) |> aoc.err_string
  }
}

fn search_combinations(xs, cur, count) {
  case xs {
    _ if cur == 0 -> count
    [] -> 1000
    [x, ..rest] -> {
      let res = int.bitwise_exclusive_or(cur, x)
      int.min(
        search_combinations(rest, cur, count),
        search_combinations(rest, res, count + 1),
      )
    }
  }
}

pub fn solution() {
  let parse = parser()
  use ls, _ <- input.try_inputs(10)
  use entries <- try(ls |> list.try_map(parse))

  entries
  //   |> echo
  |> list.map(fn(e) { search_combinations(e.switches, e.bits, 0) })
  |> echo
  |> int.sum
  |> echo
  aoc.done
}
