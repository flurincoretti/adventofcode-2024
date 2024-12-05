//
//  Day03.swift
//  AdventOfCode
//
//  Created by Flurin Coretti on 05.12.2024.
//

import Algorithms

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Read the inputs.
  var entities: [String] {
    data.split(separator: "\n").map(String.init)
  }

  // Solution for the first part of the day's challenge.
  func part1() -> Any {
    let pattern = /mul\((\d+),(\d+)\)/

    return entities.map { line -> Int in
      line.matches(of: pattern).reduce(0) { sum, match in
        let x = Int(match.output.1)!
        let y = Int(match.output.2)!
        return sum + (x * y)
      }
    }.reduce(0, +)
  }

  // Solution for the second part of the day's challenge.
  func part2() -> Any {
    let pattern = /(mul\(\d+,\d+\)|do\(\)|don't\(\))/
    var total = 0
    var enabled = true

    for line in entities {
      var position = line.startIndex
      while let match = line[position...].firstMatch(of: pattern) {
        let token = line[match.range]
        if token.hasPrefix("mul") && enabled {
          let nums = token.matches(of: /\d+/).map { Int($0.0)! }
          total += nums[0] * nums[1]
        } else if token == "don't()" {
          enabled = false
        } else if token == "do()" {
          enabled = true
        }
        position = match.range.upperBound
      }
    }
    return total
  }
}
