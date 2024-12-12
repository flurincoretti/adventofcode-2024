//
//  Day10.swift
//  AdventOfCode
//
//  Created by Flurin Coretti on 12.12.2024.
//

import Algorithms

struct Day10: AdventDay {
  var grid: [[Int]] = []

  // Read the inputs.
  init(data: String) {
    self.grid = data.split(separator: "\n").map { line in
      line.compactMap { $0.wholeNumberValue }
    }
  }

  // Find trailheads.
  func findTrailheads() -> [(row: Int, col: Int)] {
    var trailheads: [(Int, Int)] = []
    for row in 0..<grid.count {
      for col in 0..<grid[row].count {
        if grid[row][col] == 0 {
          trailheads.append((row, col))
        }
      }
    }
    return trailheads
  }

  // Count 9s reachable from trailhead.
  func countReachableNines(from trailhead: (row: Int, col: Int)) -> Int {
    let directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    var queue: [(row: Int, col: Int)] = [trailhead]
    var visited: Set<String> = ["\(trailhead.row), \(trailhead.col)"]
    var count = 0

    while !queue.isEmpty {
      let current = queue.removeFirst()
      let currentHeight = grid[current.row][current.col]

      if currentHeight == 9 {
        count += 1
        continue
      }

      for direction in directions {
        let newRow = current.row + direction.0
        let newCol = current.col + direction.1

        if newRow >= 0 && newRow < grid.count && newCol >= 0 && newCol < grid[0].count {
          let nextHeight = grid[newRow][newCol]

          if nextHeight == currentHeight + 1 {
            let positionKey = "\(newRow), \(newCol)"
            if !visited.contains(positionKey) {
              queue.append((row: newRow, col: newCol))
              visited.insert(positionKey)
            }
          }
        }
      }
    }

    return count
  }

  // Count distinct paths.
  func countDistinctPaths(from trailhead: (row: Int, col: Int)) -> Int {
    let directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    var visited: Set<String> = []
    var count = 0

    func dfs(position: (row: Int, col: Int)) {
      let currentHeight = grid[position.row][position.col]
      let positionKey = "\(position.row), \(position.col)"

      if currentHeight == 9 {
        count += 1
        return
      }

      visited.insert(positionKey)

      for direction in directions {
        let newRow = position.row + direction.0
        let newCol = position.col + direction.1

        if newRow >= 0 && newRow < grid.count && newCol >= 0 && newCol < grid[0].count {
          let nextHeight = grid[newRow][newCol]
          let newPositionKey = "\(newRow), \(newCol)"

          if nextHeight == currentHeight + 1 && !visited.contains(newPositionKey) {
            dfs(position: (row: newRow, col: newCol))
          }
        }
      }

      visited.remove(positionKey)
    }

    dfs(position: trailhead)
    return count
  }

  // Solution for the first part of the day's challenge.
  func part1() -> Any {
    let trailheads = findTrailheads()
    return trailheads.map { countReachableNines(from: $0) }.reduce(0, +)
  }

  // Solution for the second part of the day's challenge.
  func part2() -> Any {
    let trailheads = findTrailheads()
    return trailheads.map { countDistinctPaths(from: $0) }.reduce(0, +)
  }
}
