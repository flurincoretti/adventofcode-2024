//
//  Day02.swift
//  AdventOfCode
//
//  Created by Flurin Coretti on 04.12.2024.
//

import Algorithms

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }

  // Helper function that checks whether a single report is safe.
  func isSafe(_ levels: [Int]) -> Bool {
    let isOrdered = levels.sorted(by: <) == levels || levels.sorted(by: >) == levels

    var hasValidDifferences = true
    for i in 0..<(levels.count - 1) {
      let difference = abs(levels[i + 1] - levels[i])
      if difference < 1 || difference > 3 {
        hasValidDifferences = false
        break
      }
    }

    return isOrdered && hasValidDifferences
  }

  // Solution for the first part of the day's challenge.
  func part1() -> Any {
    let isReportSafe = entities.map { levels in
      if isSafe(levels) {
        return true
      }
      return false
    }

    let safeCount = isReportSafe.filter { $0 }.count

    return safeCount
  }

  // Solution for the second part of the day's challenge.
  func part2() -> Any {
    let isReportSafe = entities.map { levels in
      if isSafe(levels) {
        return true
      }

      for i in 0..<levels.count {
        var modifiedLevels = levels
        modifiedLevels.remove(at: i)
        if isSafe(modifiedLevels) {
          return true
        }
      }

      return false
    }

    let safeCount = isReportSafe.filter { $0 }.count

    return safeCount
  }
}
