import simplifile
import gleam/list
import gleam/io
import gleam/string
import gleam/int

pub fn main() -> Nil {
  compute("example.txt")
  io.println("")
  compute("input.txt")
  io.println("")
  compute2("example.txt")
  io.println("")
  compute2("input.txt")
  /// 6335 too high
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
  let history = case value {
    0 -> history + 1
    _ -> history
  }
  case int.parse(string.slice(str, 1, 5)) {
    Ok(tr) -> 
    case string.slice(str, 0, 1) {
      "L" -> case int.remainder(100 + value - tr, 100) {
        Ok(rem) -> #(rem, history)
        Error(_err) -> panic
      }
      "R" -> case int.remainder(value + tr, 100) {
        Ok(rem) -> #(rem, history)
        Error(_err) -> panic
      }
      _ -> panic
    }
    Error(_err) -> nr
  }
}

fn compute2(filename: String) -> Nil {
  case simplifile.read(filename) {
    Ok(contents) -> {
      let lines = string.split(contents, "\n")
      let #(_, history) = list.fold(lines, #(50, 0), turn2)
      io.println(int.to_string(history))
    }
    Error(_err) ->
      io.println("Could not read file.")
  }
}

pub fn turn2(nr: #(Int, Int), str: String) -> #(Int, Int) {
  let #(value, history) = nr
  case int.parse(string.slice(str, 1, 5)) {
    Ok(tr) -> 
    case string.slice(str, 0, 1) {
      "L" -> { 
        let rem = 100 + value - tr
        case int.divide(100 - value + tr, 100) {
          Ok(zeroos) -> {
            let zeros = case value == 0 {
              True -> zeroos - 1
              False -> zeroos
            }
            let rem = rem + 1000
            #(rem % 100, history + zeros)
          }
          Error(_err) -> panic
        }
      }
      "R" -> {
        let rem = value + tr
        case int.divide(value + tr, 100) {
          Ok(zeros) -> {
            #(rem % 100, history + zeros)
          }
          Error(_err) -> panic
        }
      }
      _ -> panic
    }
    Error(_err) -> nr
  }
}