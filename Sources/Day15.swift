//
//  Day15.swift
//  AdventOfCode
//
//  Created by Flurin Coretti on 19.12.2024.
//

import Algorithms

struct Day15: AdventDay {
  let grid: [[String]]
  let moves: String

  struct Position: Hashable {
    var row: Int
    var col: Int
  }

  enum Direction {
    case up, right, down, left

    var vector: Position {
      switch self {
      case .up: Position(row: -1, col: 0)
      case .right: Position(row: 0, col: 1)
      case .down: Position(row: 1, col: 0)
      case .left: Position(row: 0, col: -1)
      }
    }
  }

  func getDirection(from char: Character) -> Direction? {
    switch char {
    case "^": return .up
    case "v": return .down
    case ">": return .right
    case "<": return .left
    default: return nil
    }
  }

  func findRobotPosition() -> Position? {
    for row in grid.indices {
      for col in grid[row].indices {
        if grid[row][col] == "@" {
          return Position(row: row, col: col)
        }
      }
    }
    return nil
  }

  struct Robot {
    var position: Position

    func canMoveDistance(from: Position, direction: Direction, grid: [[String]]) -> Int {
      let nextPos = Position(
        row: from.row + direction.vector.row,
        col: from.col + direction.vector.col
      )

      guard
        nextPos.row >= 0 && nextPos.row < grid.count && nextPos.col >= 0
          && nextPos.col < grid[nextPos.row].count
      else {
        return 0
      }

      let str = grid[nextPos.row][nextPos.col]

      switch str {
      case ".": return 1
      case "#": return 0
      case "O":
        let positions = canMoveDistance(from: nextPos, direction: direction, grid: grid)
        return positions > 0 ? positions + 1 : 0
      default:
        return 0
      }
    }

    mutating func move(direction: Direction, grid: inout [[String]]) -> Bool {
      let distance = canMoveDistance(from: position, direction: direction, grid: grid)

      if distance > 0 {
        var positions: [Position] = []
        var currentPos = position

        for _ in 0...distance {
          positions.append(currentPos)
          currentPos = Position(
            row: currentPos.row + direction.vector.row,
            col: currentPos.col + direction.vector.col
          )
        }

        for i in (0..<positions.count - 1).reversed() {
          grid[positions[i + 1].row][positions[i + 1].col] =
            grid[positions[i].row][positions[i].col]
        }

        grid[position.row][position.col] = "."
        position = positions[1]
        grid[position.row][position.col] = "@"

        return true
      }

      return false
    }
  }

  func calculateTotalGPSCoordinates(in grid: [[String]]) -> Int {
    var total = 0

    for row in grid.indices {
      for col in grid[row].indices {
        if grid[row][col] == "O" {
          let gpsCoordinate = (100 * row) + col
          total += gpsCoordinate
        }
      }
    }

    return total
  }

  // Read the inputs.
  init(data: String) {
    let parts = data.split(separator: "\n\n")
    self.grid = parts[0].split(separator: "\n").map { line in
      line.compactMap { String($0) }
    }
    self.moves = parts[1].split(separator: "\n").joined()
  }

  // Solution for the first part of the day's challenge.
  func part1() -> Any {
    guard let startPosition = findRobotPosition() else {
      return 0
    }

    var robot = Robot(position: startPosition)
    var currentGrid = grid

    for move in moves {
      if let direction = getDirection(from: move) {
        _ = robot.move(direction: direction, grid: &currentGrid)
      }
    }

    return calculateTotalGPSCoordinates(in: currentGrid)
  }

  // Solution for the second part of the day's challenge.
  func part2() -> Any {
    return 0
  }
}
