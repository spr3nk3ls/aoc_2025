import simplifile
import gleam/list
import gleam/io
import gleam/string
import gleam/int
import gleam/result

pub fn main() -> Nil {
  compute("example.txt", get_dupe)
  io.println("")
  compute("input.txt", get_dupe)
  io.println("")
  compute("example.txt", get_dupe_2)
  io.println("")
  compute("input.txt", get_dupe_2)
}

fn compute(filename: String, get_dupe_function: fn(Int) -> Int) -> Nil {
  case simplifile.read(filename) {
    Ok(contents) -> {
      let dupe_sum = string.split(contents, ",")
      |> list.map(fn(x){get_number_of_dupes(x, get_dupe_function)})
      |> list.fold(0, fn(n, acc) { acc + n })
      io.print(int.to_string(dupe_sum))
    }
    Error(_err) ->
      io.println("Could not read file.")
  }
}

fn get_number_of_dupes(range_string: String, get_dupe_function: fn(Int) -> Int) -> Int {
  let #(a, b) = case string.split(range_string, "-") {
    [a, b] -> #(result.unwrap(int.parse(a), 0), result.unwrap(int.parse(b), 0))
    _ -> panic
  }
  list.range(a, b)
  |> list.map(get_dupe_function)
  |> list.fold(0, fn(n, acc) { acc + n })
}

fn get_dupe(number: Int) -> Int {
  let as_string = int.to_string(number)
  let len = string.length(as_string)
  case len % 2 == 0 && begin_and_end_equal(as_string, len) {
    True -> number
    False -> 0
  }
}

fn begin_and_end_equal(number: String, len: Int) -> Bool {
  let first = string.slice(number, 0, len/2)
  let last = string.slice(number, len/2, len)
  first == last
}

fn get_dupe_2(number: Int) -> Int {
  let as_string = int.to_string(number)
  let len = string.length(as_string)
  let repeating = {
    list.range(1, len/2)
    |> list.map(fn(window){check_repeating(window,as_string, len)})
    |> list.any(fn (x) { x })
  }
  case len > 1 && repeating {
    True -> number
    False -> 0
  }
}

fn check_repeating(window: Int, number: String, len: Int) -> Bool {
  case len % window == 0 {
    True -> {
      list.sized_chunk(string.to_graphemes(number), window )
      |> all_equal
    }
    False -> False
  }
}

fn all_equal(xs: List(List(String))) -> Bool {
  case xs {
    [] -> True
    [first, ..rest] -> all_equal_rest(first, rest)
  }
}

fn all_equal_rest(first: List(String), xs: List(List(String))) -> Bool {
  case xs {
    [] -> True
    [x, ..rest] ->
      case x == first {
        True -> all_equal_rest(first, rest)
        False -> False
      }
  }
}