import simplifile
import gleam/list
import gleam/io
import gleam/string
import gleam/int

pub fn main() -> Nil {
  compute("example.txt")
  compute("input.txt")
  compute2("example.txt")
  compute2("input.txt")
}

fn compute(filename: String) -> Nil {
  case simplifile.read(filename) {
    Ok(contents) -> {
      let rolls = get_rolls(contents) 

      let accessable = list.filter(rolls, fn(tup){
        can_be_accessed(tup, rolls)
      })

      io.println(int.to_string(list.length(accessable)))
    }
    Error(_err) ->
      io.println("Could not read file.")
  }
}

fn compute2(filename: String) -> Nil {
  case simplifile.read(filename) {
    Ok(contents) -> {
      let rolls = get_rolls(contents) 

      let #(removed, _rolls) = compute_recurse(#(0, rolls))

      io.println(int.to_string(removed))
    }
    Error(_err) ->
      io.println("Could not read file.")
  }
}

fn compute_recurse(removed_and_rolls: #(Int, List(#(Int, Int)))) -> #(Int, List(#(Int, Int))) {
  let #(removed, rolls) = removed_and_rolls
  let accessable = list.filter(rolls, fn(tup){
    can_be_accessed(tup, rolls)
  })
  let number_accessable = list.length(accessable)
  case number_accessable {
    0 -> #(removed, rolls)
    _ -> {
      let rolls = list.filter(rolls, fn(roll){!list.contains(accessable, roll)})
      compute_recurse(#(removed + number_accessable, rolls))
    }
  }
}

fn get_rolls(contents: String) -> List(#(Int, Int)){
  let rows = string.split(contents, "\n")
  let indexed_rows = indexed(rows)
  let rolls_nested = list.map(indexed_rows, fn(row_item){
    let #(y, row) = row_item
    let cols = string.to_graphemes(row)
    let indexed_cols = indexed(cols)
    list.filter_map(indexed_cols, fn(col_item) {
      let #(x, col) = col_item
      case col {
        "@" -> Ok(#(x, y))
        _ -> Error(Nil)
      }
    })
  })
  list.flatten(rolls_nested)
}

fn indexed(xs: List(a)) -> List(#(Int, a)) {
  let #(indexed, _) =
    list.fold(xs, #([], 0), fn(tup, item) {
      let #(acc, i) = tup
      #( [#(i, item), ..acc], i + 1 )
    })
  list.reverse(indexed)
}

fn can_be_accessed(tup: #(Int, Int), rolls: List(#(Int, Int))) -> Bool {
  let adjacent = get_adjacent(tup)
  let matches = list.filter(adjacent, fn(a){ list.contains(rolls, a) })
  list.length(matches) < 4
}

fn get_adjacent(tup: #(Int, Int)) -> List(#(Int, Int)){
  let #(x, y) = tup
  [#(x - 1, y - 1), #(x - 1, y), #(x - 1, y + 1), #(x, y - 1), #(x, y + 1), #(x + 1, y - 1), #(x + 1, y), #(x + 1, y + 1)]
}