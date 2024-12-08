//
//  Day06.swift
//  AdventOfCode
//
//  Created by Flurin Coretti on 08.12.2024.
//

import Algorithms

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

  func turnRight() -> Direction {
    switch self {
    case .up: return .right
    case .right: return .down
    case .down: return .left
    case .left: return .up
    }
  }
}

struct Guard {
  var position: Position
  var direction: Direction

  mutating func turnRight() {
    direction = direction.turnRight()
  }

  mutating func moveForward() {
    let vector = direction.vector
    position = Position(
      row: position.row + vector.row,
      col: position.col + vector.col
    )
  }
}

struct GuardState: Hashable {
  let position: Position
  let direction: Direction
}

struct Grid {
  private let cells: [[Bool]]
  let height: Int
  let width: Int

  static func parse(_ input: String) -> (Grid, Guard) {
    let lines = input.split(separator: "\n")
    let initialGuardPosition = lines.enumerated()
      .flatMap { row, line in
        line.enumerated().compactMap { col, char in
          let pos = Position(row: row, col: col)
          switch char {
          case "^": return Guard(position: pos, direction: .up)
          case ">": return Guard(position: pos, direction: .right)
          case "v": return Guard(position: pos, direction: .down)
          case "<": return Guard(position: pos, direction: .left)
          default: return nil
          }
        }
      }
      .first!

    return (Grid(string: input), initialGuardPosition)
  }

  private init(cells: [[Bool]], height: Int, width: Int) {
    self.cells = cells
    self.height = height
    self.width = width
  }

  init(string: String) {
    let cells = string.split(separator: "\n").map { line in
      line.map { $0 == "#" }
    }
    self.init(cells: cells, height: cells.count, width: cells[0].count)
  }

  init(cells: [[Bool]]) {
    self.init(cells: cells, height: cells.count, width: cells[0].count)
  }

  func contains(_ pos: Position) -> Bool {
    pos.row >= 0 && pos.row < height && pos.col >= 0 && pos.col < width
  }

  func hasObstacle(at pos: Position) -> Bool {
    cells[pos.row][pos.col]
  }

  func hasObstacleAhead(_ patrollingGuard: Guard) -> Bool {
    let vector = patrollingGuard.direction.vector
    let nextPosition = Position(
      row: patrollingGuard.position.row + vector.row,
      col: patrollingGuard.position.col + vector.col
    )

    return contains(nextPosition) && hasObstacle(at: nextPosition)
  }

  func addObstacle(at position: Position) -> Grid {
    var newCells = cells
    newCells[position.row][position.col] = true
    return Grid(cells: newCells)
  }

  func createsLoop(addingObstacleAt position: Position, startingGuard: Guard) -> Bool {
    let modifiedGrid = addObstacle(at: position)
    return modifiedGrid.simulate(startingGuard: startingGuard)
  }

  func simulate(startingGuard: Guard) -> Bool {
    var visitedStates = Set<GuardState>()
    var currentPatrol = startingGuard

    while contains(currentPatrol.position) {
      let currentState = GuardState(
        position: currentPatrol.position,
        direction: currentPatrol.direction
      )

      if visitedStates.contains(currentState) {
        return true
      }

      visitedStates.insert(currentState)

      if hasObstacleAhead(currentPatrol) {
        currentPatrol.turnRight()
      } else {
        currentPatrol.moveForward()
      }
    }
    return false
  }
}

struct Day06: AdventDay {
  var grid: Grid
  var patrollingGuard: Guard

  // Read the inputs.
  init(data: String) {
    (self.grid, self.patrollingGuard) = Grid.parse(data)
  }

  // Solution for the first part of the day's challenge.
  func part1() -> Any {
    var visitedPositions = Set<Position>()
    var currentPatrol = patrollingGuard

    visitedPositions.insert(currentPatrol.position)

    while grid.contains(currentPatrol.position) {
      if grid.hasObstacleAhead(currentPatrol) {
        currentPatrol.turnRight()
      } else {
        currentPatrol.moveForward()
        if grid.contains(currentPatrol.position) {
          visitedPositions.insert(currentPatrol.position)
        }
      }
    }
    return visitedPositions.count
  }

  // Solution for the second part of the day's challenge.
  func part2() -> Any {
    var positionsThatCreateLoop = Set<Position>()

    for row in 0..<grid.height {
      for col in 0..<grid.width {
        let position = Position(row: row, col: col)
        if position != patrollingGuard.position && !grid.hasObstacle(at: position)
          && grid.createsLoop(addingObstacleAt: position, startingGuard: patrollingGuard)
        {
          positionsThatCreateLoop.insert(position)
        }
      }
    }

    return positionsThatCreateLoop.count
  }
}
