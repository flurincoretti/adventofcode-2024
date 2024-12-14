//
//  Day11.swift
//  AdventOfCode
//
//  Created by Flurin Coretti on 14.12.2024.
//

import Algorithms

struct Day11: AdventDay {
  var stoneCounts: [Int: Int]

  // Read the inputs.
  init(data: String) {
    self.stoneCounts = data.split(separator: " ")
      .compactMap { Int($0.trimmingCharacters(in: .whitespacesAndNewlines)) }
      .reduce(into: [:]) { counts, stone in
        counts[stone, default: 0] += 1
      }
  }

  func blink(_ dict: [Int: Int]) -> [Int: Int] {
    var newStoneCounts: [Int: Int] = [:]

    for (stone, count) in dict {
      if stone == 0 {
        newStoneCounts[1, default: 0] += count
      } else if String(stone).count.isMultiple(of: 2) {
        let numStr = String(stone)
        let i = numStr.count / 2
        let leftNum = Int(numStr.prefix(i)) ?? 0
        let rightNum = Int(numStr.suffix(i)) ?? 0
        newStoneCounts[leftNum, default: 0] += count
        newStoneCounts[rightNum, default: 0] += count
      } else {
        newStoneCounts[stone * 2024, default: 0] += count
      }
    }
    return newStoneCounts
  }

  // Solution for the first part of the day's challenge.
  func part1() -> Any {
    var counts = stoneCounts
    for _ in 1...25 {
      counts = blink(counts)
    }
    return counts.values.reduce(0, +)
  }

  // Solution for the second part of the day's challenge.
  func part2() -> Any {
    var counts = stoneCounts
    for _ in 1...75 {
      counts = blink(counts)
    }
    return counts.values.reduce(0, +)
  }
}
