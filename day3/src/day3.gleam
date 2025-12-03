import simplifile
import gleam/list
import gleam/io
import gleam/string
import gleam/int
import gleam/result

pub fn main() -> Nil {
  compute("example.txt")
  io.println("")
  compute("input.txt")
  io.println("")
  /// compute2("example.txt")
  io.println("")
  /// compute2("input.txt")
}

fn compute(filename: String) -> Nil {
  case simplifile.read(filename) {
    Ok(contents) -> {
      let result = string.split(contents, "\n")
      |> list.map(to_ints)
      |> list.map(get_joltage)
      |> list.fold(0, fn(n, acc) { acc + n })

      io.println(int.to_string(result))
    }
    Error(_err) ->
      io.println("Could not read file.")
  }
}

fn to_ints(str: String) -> List(Int) {
  string.to_graphemes(str)
  |> list.map(fn(x) {
    case int.parse(x) {
      Ok(p) -> p
      Error(_) -> 0
    } 
  }
  )
}

fn get_joltage(ls: List(Int)) -> Int {
  let mx = ls
    |> list.reverse
    |> list.rest
    |> result.unwrap([0])
    |> list.reverse
    |> list.max(int.compare)
    |> result.unwrap(0)

  let mx2 = ls
    |> split_on_pred(fn(x){x == mx})
    |> fn(tup){ tup.1 }
    |> list.max(int.compare)
    |> result.unwrap(0)
  
  /// io.println(int.to_string(mx*10 + mx2))
  mx*10 + mx2
}

fn split_on_pred(xs: List(Int), pred: fn(Int) -> Bool)
    -> #(List(Int), List(Int)) {
  go(xs, [], pred)
}

fn go(rest, acc, pred) {
  case rest {
    [] ->
      #(list.reverse(acc), [])

    [x, ..xs2] ->
      case pred(x) {
        True -> #(list.reverse(acc), xs2)
        False -> go(xs2, [x, ..acc], pred)
      }
  }
}