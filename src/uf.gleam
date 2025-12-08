import gleam/dict.{type Dict}
import gleam/list

pub type UFNode(k) {
  Root(Int)
  Parent(k)
}

pub type UF(k) =
  Dict(k, UFNode(k))

pub fn init(keys) -> UF(k) {
  keys |> list.map(fn(k) { #(k, Root(1)) }) |> dict.from_list
}

pub fn of_size(x: Int) {
  list.range(0, x - 1) |> init
}

fn root_update(uf: UF(k), k) -> #(UF(k), k, Int) {
  case dict.get(uf, k) {
    Error(_) -> #(uf, k, 0)
    Ok(Root(i)) -> #(uf, k, i)
    Ok(Parent(p)) -> {
      let #(d1, r, s) = root_update(uf, p)
      #(dict.insert(d1, k, Parent(r)), r, s)
    }
  }
}

pub fn root_size(uf, k) -> Int {
  let #(_, _, d) = root_update(uf, k)
  d
}

pub fn merge(uf: Dict(k, UFNode(k)), k1: k, k2: k) -> UF(k) {
  let #(uf1, r1, s1) = root_update(uf, k1)
  let #(uf2, r2, s2) = root_update(uf1, k2)
  case r1 == r2 {
    True -> uf2
    False -> {
      let #(l, f) = case s1 > s2 {
        True -> #(r1, r2)
        False -> #(r2, r1)
      }
      uf2 |> dict.insert(l, Root(s1 + s2)) |> dict.insert(f, Parent(l))
    }
  }
}
