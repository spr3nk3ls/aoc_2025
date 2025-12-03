import simplifile
import gleam/list
import gleam/io
import gleam/string
import gleam/int
import gleam/result

pub fn main() -> Nil {
  compute("example.txt", 2)
  compute("input.txt", 2)
  compute("example.txt", 12)
  compute("input.txt", 12)
}

fn compute(filename: String, numbers: Int) -> Nil {
  case simplifile.read(filename) {
    Ok(contents) -> {
      let result = string.split(contents, "\n")
      |> list.map(to_ints)
      |> list.map(fn(ls){get_joltage(ls, numbers)})
      |> list.map(
          fn(l){
            list.fold(l, 0, fn(n, acc){ 10*n + acc })
          }
        )
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

fn get_joltage(ls: List(Int), numbers: Int) -> List(Int) {
  let mx = ls
    |> list.reverse
    |> list.drop(numbers - 1)
    |> list.reverse
    |> list.max(int.compare)
    |> result.unwrap(0)
  
  case numbers {
    1 -> [mx]
    _ -> {
      let sublist = ls
        |> split_on_pred(fn(x){x == mx})
        |> fn(tup){ tup.1 }
      [mx, ..get_joltage(sublist, numbers - 1)]
    }
  }
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