//
//  Day12.swift
//  AdventOfCode
//
//  Created by Flurin Coretti on 16.12.2024.
//

import Algorithms

struct Day12: AdventDay {
  var grid: [[Character]]

  // Read the inputs.
  init(data: String) {
    self.grid = data.split(separator: "\n").map { line in
      line.compactMap { $0 }
    }
  }

  struct Position: Hashable {
    let row: Int
    let col: Int
  }

  enum Side {
    case top
    case bottom
    case left
    case right
  }

  enum Orientation {
    case horizontal
    case vertical
  }

  struct SideSegment: Hashable {
    let row: Int
    let col: Int
    let side: Side
  }

  func isValid(_ pos: Position) -> Bool {
    pos.row >= 0 && pos.row < grid.count && pos.col >= 0 && pos.col < grid[0].count
  }

  func getAdjacent(_ pos: Position) -> [Position] {
    let directions = [
      (0, 1),
      (1, 0),
      (0, -1),
      (-1, 0),
    ]

    return directions.compactMap { direction in
      let newPosition = Position(
        row: pos.row + direction.0,
        col: pos.col + direction.1
      )
      return isValid(newPosition) ? newPosition : nil
    }
  }

  func findRegionPerimeter(startingAt: Position, letter: Character, visited: inout Set<Position>)
    -> (area: Int, perimeter: Int)
  {
    if !isValid(startingAt) || visited.contains(startingAt)
      || grid[startingAt.row][startingAt.col] != letter
    {
      return (0, 0)
    }

    visited.insert(startingAt)

    var area = 1
    var perimeter = 4

    for pos in getAdjacent(startingAt) {
      if grid[pos.row][pos.col] == letter {
        perimeter -= 1
        if !visited.contains(pos) {
          let (nextArea, nextPerimeter) = findRegionPerimeter(
            startingAt: pos, letter: letter, visited: &visited)
          area += nextArea
          perimeter += nextPerimeter
        }
      }
    }

    return (area, perimeter)
  }

  func findRegionSides(startingAt: Position, letter: Character, visited: inout Set<Position>) -> (
    area: Int, sides: Int
  ) {
    var stack = [startingAt]
    var positions = [Position]()
    visited.insert(startingAt)

    while !stack.isEmpty {
      let currentPos = stack.removeLast()
      positions.append(currentPos)

      for pos in getAdjacent(currentPos) {
        if !visited.contains(pos) && grid[pos.row][pos.col] == letter {
          visited.insert(pos)
          stack.append(pos)
        }
      }
    }

    let area = positions.count
    var segments = Set<SideSegment>()

    for pos in positions {
      let row = pos.row
      let col = pos.col

      if row == 0 || grid[row - 1][col] != letter {
        segments.insert(SideSegment(row: row, col: col, side: .top))
      }

      if row == grid.count - 1 || grid[row + 1][col] != letter {
        segments.insert(SideSegment(row: row + 1, col: col, side: .bottom))
      }

      if col == 0 || grid[row][col - 1] != letter {
        segments.insert(SideSegment(row: row, col: col, side: .left))
      }

      if col == grid[0].count - 1 || grid[row][col + 1] != letter {
        segments.insert(SideSegment(row: row, col: col + 1, side: .right))
      }
    }

    var totalSides = 0
    var processedSegments = Set<SideSegment>()

    for segment in segments {
      if processedSegments.contains(segment) {
        continue
      }

      totalSides += 1
      processedSegments.insert(segment)

      var stack = [segment]

      while !stack.isEmpty {
        let current = stack.removeLast()
        let nextSegments: [SideSegment]

        switch current.side {
        case .top, .bottom:
          nextSegments = [
            SideSegment(row: current.row, col: current.col - 1, side: current.side),
            SideSegment(row: current.row, col: current.col + 1, side: current.side),
          ]
        case .left, .right:
          nextSegments = [
            SideSegment(row: current.row - 1, col: current.col, side: current.side),
            SideSegment(row: current.row + 1, col: current.col, side: current.side),
          ]
        }

        for next in nextSegments {
          if segments.contains(next) && !processedSegments.contains(next) {
            processedSegments.insert(next)
            stack.append(next)
          }
        }
      }
    }

    return (area, totalSides)
  }

  // Solution for the first part of the day's challenge.
  func part1() -> Any {
    var visited = Set<Position>()
    var totalPrice = 0

    for row in 0..<grid.count {
      for col in 0..<grid[0].count {
        let pos = Position(row: row, col: col)

        if !visited.contains(pos) {
          let letter = grid[row][col]
          let (area, perimeter) = findRegionPerimeter(
            startingAt: pos, letter: letter, visited: &visited)
          totalPrice += area * perimeter
        }
      }
    }

    return totalPrice
  }

  // Solution for the second part of the day's challenge.
  func part2() -> Any {
    var visited = Set<Position>()
    var totalPrice = 0

    for row in 0..<grid.count {
      for col in 0..<grid[0].count {
        let pos = Position(row: row, col: col)

        if !visited.contains(pos) {
          let letter = grid[row][col]
          let (area, sides) = findRegionSides(startingAt: pos, letter: letter, visited: &visited)
          totalPrice += area * sides
        }
      }
    }

    return totalPrice
  }
}
