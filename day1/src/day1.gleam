import simplifile
import gleam/list
import gleam/io
import gleam/string
import gleam/int

pub fn main() -> Nil {
  compute("example.txt")
  io.println("")
  compute("input.txt")
}

fn compute(filename: String) -> Nil {
  case simplifile.read(filename) {
    Ok(contents) -> {
      let lines = string.split(contents, "\n")
      let #(_, history) = list.fold(lines, #(50, 0), turn)
      io.println(int.to_string(history))
    }
    Error(_err) ->
      io.println("Could not read file.")
  }
}

fn turn(nr: #(Int, Int), str: String) -> #(Int, Int) {
  let #(value, history) = nr
  /// io.println(int.to_string(value))
  let history = case value {
    0 -> history + 1
    _ -> history
  }
  case int.parse(string.slice(str, 1, 5)) {
    Ok(tr) -> 
    case string.slice(str, 0, 1) {
      "L" -> case int.remainder(100 + value - tr, 100) {
        Ok(rem) -> #(rem, history)
        Error(_err) -> nr
      }
      "R" -> case int.remainder(value + tr, 100) {
        Ok(rem) -> #(rem, history)
        Error(_err) -> nr
      }
      _ -> nr
    }
    Error(_err) -> nr
  }
}