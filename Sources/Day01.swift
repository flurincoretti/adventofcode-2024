//
//  Day01.swift
//  AdventOfCode
//
//  Created by Flurin Coretti on 03.12.2024.
//

import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }

  // Solution for the first part of the day's challenge.
  func part1() -> Any {
    // Extract both lists
    let leftList = entities.map { $0[0] }
    let rightList = entities.map { $0[1] }

    // Sort both lists
    let sortedLeftList = leftList.sorted()
    let sortedRightList = rightList.sorted()

    // Subtract corresponding elements
    let distances = zip(sortedLeftList, sortedRightList).map { abs($0 - $1) }

    // Add up all distances
    let totalDistance = distances.reduce(0, +)

    return totalDistance
  }

  // Solution for the second part of the day's challenge.
  func part2() -> Any {
    // Extract both lists
    let leftList = entities.map { $0[0] }
    let rightList = entities.map { $0[1] }

    // Count occurrences of each number in the right list
    let rightCounts = Dictionary(rightList.map { ($0, 1) }, uniquingKeysWith: +)

    // Calculate the total similarity score
    let totalScore = leftList.reduce(0) { score, number in
      score + (number * (rightCounts[number] ?? 0))
    }

    return totalScore
  }
}
