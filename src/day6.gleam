import aoc
import gleam/int
import gleam/io
import gleam/list.{map, map2, transpose, try_map}
import gleam/result.{try}
import gleam/string
import input

type Op {
  Mul
  Add
}

fn op_from_string(s) {
  case s {
    "*" -> Ok(Mul)
    "+" -> Ok(Add)
    _ -> Error("bad operation" <> s)
  }
}

fn apply_op(ls, op) {
  case op {
    Mul -> list.fold(ls, 1, fn(x, y) { x * y })
    Add -> list.fold(ls, 0, fn(x, y) { x + y })
  }
}

fn parse_line(s) {
  string.split(s, " ") |> list.filter(fn(s) { !string.is_empty(s) })
}

type InputLine {
  Num(x: Int)
  NumAndOp(x: Int, op: Op)
  Empty
}

fn parse_int_ls(s) {
  s |> string.join("") |> string.trim |> aoc.parse_int
}

fn parse_num(s) -> Result(InputLine, _) {
  let p = s |> list.filter(fn(s) { s != " " })
  case list.split(p, list.length(p) - 1) {
    #(pref, [ops]) ->
      {
        use num <- result.try(parse_int_ls(pref))
        use op <- try(op_from_string(ops))
        Ok(NumAndOp(num, op))
      }
      |> result.or(parse_int_ls(s) |> result.map(Num))
    _ -> Ok(Empty)
  }
}

fn reduce_ops(xs, op, cur, sum) {
  case xs {
    [first, ..rest] ->
      case first {
        Empty -> reduce_ops(rest, op, cur, sum)
        Num(x) -> reduce_ops(rest, op, apply_op([cur, x], op), sum)
        NumAndOp(x, op) -> reduce_ops(rest, op, x, sum + cur)
      }
    [] -> cur + sum
  }
}

pub fn solution() {
  use ls <- input.inputs(6)
  io.println("part1")
  let assert [ops, ..nums] = list.reverse(ls |> map(parse_line))
  let opl = ops |> list.try_map(op_from_string) |> result.unwrap([])
  let xs =
    list.transpose(
      nums
      |> list.try_map(list.try_map(_, int.parse))
      |> result.unwrap([]),
    )
    |> map2(opl, apply_op)
    |> int.sum
  echo xs
  io.println("part2")
  let assert Ok(parts) =
    transpose(ls |> map(string.to_graphemes))
    |> try_map(parse_num)
  let res = reduce_ops(parts, Add, 0, 0)

  echo res
  Nil
}
