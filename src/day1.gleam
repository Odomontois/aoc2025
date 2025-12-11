import aoc
import gleam/int
import gleam/order
import gleam/string
import input

fn zero_count(ls: List(String), cur: Int, zs: Int, rzs: Int) -> #(Int, Int) {
  case ls {
    [cmd, ..rest] -> {
      let assert Ok(mod) = int.parse(string.drop_start(cmd, 1))
      let assert Ok(init) = string.first(cmd)
      let x = case init {
        "L" -> -mod
        "R" -> mod
        letter -> panic as { "not L or R but " <> letter }
      }
      let raw = cur + x
      let #(next, arz) = case int.compare(raw, 0) {
        order.Lt -> {
          let next = { 100 + raw % 100 } % 100
          let rot = -{ raw / 100 }
          case cur {
            0 -> #(next, rot)
            _ -> #(next, 1 + rot)
          }
        }
        order.Eq -> #(0, 1)
        order.Gt -> #(raw % 100, raw / 100)
      }
      let az = case next == 0 {
        True -> 1
        False -> 0
      }
      echo #(next, az, arz)
      zero_count(rest, next, zs + az, rzs + arz)
    }
    [] -> #(zs, rzs)
  }
}

pub fn solution() {
  use ls, _ <- input.lines(1)

  echo zero_count(ls, 50, 0, 0)
  aoc.done
}
