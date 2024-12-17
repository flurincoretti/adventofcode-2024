//
//  Day13.swift
//  AdventOfCode
//
//  Created by Flurin Coretti on 17.12.2024.
//

import Algorithms

struct Day13: AdventDay {
  var machines: [ClawMachine]

  struct Position {
    let x: Int
    let y: Int
  }

  struct Button {
    let moveBy: Position
    let cost: Int

    func apply(to position: Position) -> Position {
      return Position(x: position.x + moveBy.x, y: position.y + moveBy.y)
    }
  }

  struct ClawMachine {
    let buttonA: Button
    let buttonB: Button
    let prize: Position

    //    func findMinimumTokens() -> Int? {
    //      var minTokens = Int.max
    //      var foundSolution = false
    //
    //      for pressesA in 0...100 {
    //        for pressesB in 0...100 {
    //          let position = Position(
    //            x: pressesA * buttonA.moveBy.x + pressesB * buttonB.moveBy.x,
    //            y: pressesA * buttonA.moveBy.y + pressesB * buttonB.moveBy.y
    //          )
    //
    //          if position.x == prize.x && position.y == prize.y {
    //            foundSolution = true
    //            let tokens = pressesA * buttonA.cost + pressesB * buttonB.cost
    //            minTokens = min(minTokens, tokens)
    //          }
    //        }
    //      }
    //      return foundSolution ? minTokens : nil
    //    }

    func findMinimumTokens(withOffset offset: Position) -> Int? {
      let adjustedPrize = Position(x: prize.x + offset.x, y: prize.y + offset.y)

      let ax = buttonA.moveBy.x
      let ay = buttonA.moveBy.y
      let bx = buttonB.moveBy.x
      let by = buttonB.moveBy.y
      let px = adjustedPrize.x
      let py = adjustedPrize.y

      // For each machine we need to solve the equations
      // a * ax + b * bx = px (1)
      // a * ay + b * by = py (2)
      // where a, b are the number of button presses.
      // We can express b as
      // b = (py * ax - px * ay) / (by * ax - bx * ay)

      let numerator = py * ax - px * ay
      let denominator = by * ax - bx * ay

      if denominator == 0 {
        return nil
      }

      // Check if b is an integer.
      if numerator % denominator != 0 {
        return nil
      }

      // Calculate b.
      let b = numerator / denominator

      // Verify that b is non-negative.
      if b < 0 {
        return nil
      }

      // Substitute b back into equation (1) to solve for a.
      let remainder = px - bx * b

      // If A_x is 0, we need to check if equation can be satisfied.
      if ax == 0 {
        if remainder != 0 {
          return nil
        } else {
          return b
        }
      }

      // Check if a is an integer.
      if remainder % ax != 0 {
        return nil
      }

      // Calculate a.
      let a = remainder / ax

      // Verify that a is non-negative.
      if a < 0 {
        return nil
      }

      // Calculate the total cost.
      return 3 * a + b
    }
  }

  // Read the inputs.
  init(data: String) {
    let extractNumber = { (str: Substring) -> Int in
      let numStr =
        str.contains("+")
        ? str.split(separator: "+")[1]
        : str.split(separator: "=")[1]
      return Int(numStr)!
    }

    let parseCoordinates = { (line: Substring) -> Position in
      let coords = line.split(separator: ":")[1]
        .split(separator: ",")
      return Position(
        x: extractNumber(coords[0]),
        y: extractNumber(coords[1])
      )
    }

    let parseButton = { (line: Substring, cost: Int) -> Button in
      let pos = parseCoordinates(line)
      return Button(moveBy: pos, cost: cost)
    }

    self.machines = data.split(separator: "\n\n").map { group in
      let lines = group.split(separator: "\n")
      return ClawMachine(
        buttonA: parseButton(lines[0], 3),
        buttonB: parseButton(lines[1], 1),
        prize: parseCoordinates(lines[2])
      )
    }
  }

  // Solution for the first part of the day's challenge.
  func part1() -> Any {
    let offset = Position(x: 0, y: 0)
    return machines.compactMap { $0.findMinimumTokens(withOffset: offset) }.reduce(0, +)
  }

  // Solution for the second part of the day's challenge.
  func part2() -> Any {
    let offset = Position(x: 10_000_000_000_000, y: 10_000_000_000_000)
    return machines.compactMap { $0.findMinimumTokens(withOffset: offset) }.reduce(0, +)
  }
}
