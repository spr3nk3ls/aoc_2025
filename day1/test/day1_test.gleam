import gleeunit
import gleeunit/should
import day1

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn turn2_test() {
  day1.turn2(#(0, 0), "R100")
  |> should.equal(#(0, 1))

  day1.turn2(#(0, 0), "L100")
  |> should.equal(#(0, 1))
  
  day1.turn2(#(0, 5), "R500")
  |> should.equal(#(0, 10))
  
  day1.turn2(#(0, 5), "L500")
  |> should.equal(#(0, 10))
  
  day1.turn2(#(0, 3), "R245")
  |> should.equal(#(45, 5))
  
  day1.turn2(#(0, 3), "L245")
  |> should.equal(#(55, 5))
}
