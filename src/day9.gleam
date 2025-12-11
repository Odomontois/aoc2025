import aoc
import gleam/int.{max, min}
import gleam/list
import gleam/result.{try}
import gleam/string
import input

type Rectangle {
  Rectangle(left: Int, right: Int, bottom: Int, top: Int)
}

fn rectangle(pp) {
  let #(#(x1, y1), #(x2, y2)) = pp
  Rectangle(min(x1, x2) + 1, max(x1, x2) - 1, min(y1, y2) + 1, max(y1, y2) - 1)
}

type Line {
  Vertical(x: Int, bottom: Int, top: Int)
  Horizontal(y: Int, left: Int, right: Int)
}

fn line(pp) {
  let #(#(x1, y1), #(x2, y2)) = pp
  case x1 == x2 {
    True -> Ok(Vertical(x1, min(y1, y2), max(y1, y2)))
    False ->
      case y1 == y2 {
        True -> Ok(Horizontal(y1, min(x1, x2), max(x1, x2)))
        False -> {
          let str =
            [x1, y1, x2, y2] |> list.map(int.to_string) |> string.join(";")
          Error("points" <> str <> "are not aligned")
        }
      }
  }
}

fn between(x, l, u) {
  l < x && x < u
}

// fn inside(r: Rectangle, p) {
//   let #(x, y) = p
//   between(x, r.left, r.right) && between(y, r.bottom, r.top)
// }

fn area(r: Rectangle) {
  { r.right - r.left + 4 } * { r.top - r.bottom + 4 } / 4
}

fn center(r: Rectangle) {
  #({ r.right + r.left } / 2, { r.top + r.bottom } / 2)
}

fn sides(r: Rectangle) {
  [
    Vertical(r.left, r.bottom, r.top),
    Vertical(r.right, r.bottom, r.top),
    Horizontal(r.bottom, r.left, r.right),
    Horizontal(r.top, r.left, r.right),
  ]
}

fn largest_area(ls) {
  let assert Ok(r) = ls |> list.max(aoc.on(int.compare, area))
  #(r, area(r))
}

fn intersect_in(x, y, left, right, bottom, top) {
  between(x, left, right) && between(y, bottom, top)
}

fn intersects(l1, l2) {
  case l1, l2 {
    Vertical(x, bottom, top), Horizontal(y, left, right) -> {
      intersect_in(x, y, left, right, bottom, top)
    }
    Horizontal(y, left, right), Vertical(x, bottom, top) -> {
      intersect_in(x, y, left, right, bottom, top)
    }
    _, _ -> False
  }
}

fn good_rect(r: Rectangle, ls: List(Line)) {
  !{
    use l <- list.any(ls)
    use s <- list.any(sides(r))
    intersects(l, s)
  }
  && {
    let #(cx, cy) = center(r)
    let beam = Horizontal(cy, cx, 10_000_000)
    let inside =
      list.fold(ls, 0, fn(x, l) { x + aoc.bool_to_int(intersects(beam, l)) })
    inside % 2 == 1
  }
}

pub fn solution() {
  use ls, _ <- input.lines(9)
  use points <- try(
    list.try_map(ls, fn(s) {
      use is <- try(string.split(s, ",") |> list.try_map(aoc.parse_int))
      case is {
        [x, y] -> Ok(#(x * 2, y * 2))
        _ -> Error("expecting pair of numbers, got " <> s)
      }
    }),
  )

  let rects = list.combination_pairs(points) |> list.map(rectangle)

  let empty_err = result.replace_error(_, "empty points")
  use ends <- try({
    use l <- try(list.last(points) |> empty_err)
    use f <- try(list.first(points) |> empty_err)
    line(#(l, f))
  })

  use rest_lines <- try(points |> list.window_by_2 |> list.try_map(line))
  let lines = [ends, ..rest_lines] |> echo

  rects
  |> largest_area
  |> echo

  rects
  |> list.filter(good_rect(_, lines))
  |> largest_area
  |> echo

  aoc.done
}
