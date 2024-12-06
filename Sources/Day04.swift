//
//  Day04.swift
//  AdventOfCode
//
//  Created by Flurin Coretti on 06.12.2024.
//

import Algorithms

struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Read the inputs.
  let entities: [[Character]]
  init(data: String) {
    self.data = data
    self.entities = data.split(separator: "\n").map { line in
      Array(line)
    }
  }

  // Check bounds.
  func isWithinBounds(row: Int, col: Int) -> Bool {
    return row >= 0 && row < entities.count && col >= 0 && col < entities[0].count
  }

  // Check characters in a given direction.
  func checkDirection(fromRow: Int, fromCol: Int, dir: (Int, Int)) -> Bool {
    // Compute the positions for 'M', 'A', 'S' in the given direction.
    let pos1 = (fromRow + dir.0, fromCol + dir.1)  // 'M'
    let pos2 = (fromRow + 2 * dir.0, fromCol + 2 * dir.1)  // 'A'
    let pos3 = (fromRow + 3 * dir.0, fromCol + 3 * dir.1)  // 'S'

    // Check if all positions are within bounds.
    if !isWithinBounds(row: pos1.0, col: pos1.1) { return false }
    if !isWithinBounds(row: pos2.0, col: pos2.1) { return false }
    if !isWithinBounds(row: pos3.0, col: pos3.1) { return false }

    // Check if the characters match.
    return entities[pos1.0][pos1.1] == "M" && entities[pos2.0][pos2.1] == "A"
      && entities[pos3.0][pos3.1] == "S"
  }

  // Check characters in a given diagonal.
  func checkDiagonal(fromRow: Int, fromCol: Int, dir: (Int, Int)) -> Bool {
    let pos1 = (fromRow - dir.0, fromCol - dir.1)
    let pos2 = (fromRow + dir.0, fromCol + dir.1)

    // Check if all positions are within bounds.
    if !isWithinBounds(row: pos1.0, col: pos1.1) { return false }
    if !isWithinBounds(row: pos2.0, col: pos2.1) { return false }

    // Check if the characters match.
    let first = entities[pos1.0][pos1.1]
    let second = entities[pos2.0][pos2.1]
    return (first == "M" && second == "S") || (first == "S" && second == "M")
  }

  // Solution for the first part of the day's challenge.
  func part1() -> Any {
    let directions = [
      (0, 1),  // → right
      (1, 1),  // ↘ down-right
      (1, 0),  // ↓ down
      (1, -1),  // ↙ down-left
      (0, -1),  // ← left
      (-1, -1),  // ↖ up-left
      (-1, 0),  // ↑ up
      (-1, 1),  // ↗ up-right
    ]

    var count = 0

    for row in 0..<entities.count {
      for col in 0..<entities[0].count {
        if entities[row][col] == "X" {
          for dir in directions {
            if checkDirection(fromRow: row, fromCol: col, dir: dir) {
              count += 1
            }
          }
        }
      }
    }

    return count
  }

  // Solution for the second part of the day's challenge.
  func part2() -> Any {
    var count = 0

    for row in 0..<entities.count {
      for col in 0..<entities[0].count {
        if entities[row][col] == "A" {
          if checkDiagonal(fromRow: row, fromCol: col, dir: (1, 1))
            && checkDiagonal(fromRow: row, fromCol: col, dir: (1, -1))
          {
            count += 1
          }
        }
      }
    }

    return count
  }
}
