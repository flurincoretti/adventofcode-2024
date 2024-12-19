//
//  Day14.swift
//  AdventOfCode
//
//  Created by Flurin Coretti on 18.12.2024.
//

import Algorithms

struct Robot {
  let position: (x: Int, y: Int)
  let velocity: (vx: Int, vy: Int)
}

struct Day14: AdventDay {
  let width: Int
  let height: Int
  var robots: [Robot] = []

  // Read the inputs.
  init(data: String) {
    self.width = 101
    self.height = 103
    self.robots = data.split(separator: "\n").map(parseLine)
  }

  // Custom initializer for testing
  init(data: String, width: Int, height: Int) {
    self.width = width
    self.height = height
    self.robots = data.split(separator: "\n").map(parseLine)
  }

  func parsePair(_ str: String) -> (Int, Int) {
    let pair = str.split(separator: ",").compactMap { Int(String($0)) }
    return (pair[0], pair[1])
  }

  func parseLine(_ line: Substring) -> Robot {
    let parts = line.split(separator: " ")
      .map { part -> (String, (Int, Int)) in
        let dict = part.split(separator: "=")
        return (String(dict[0]), parsePair(String(dict[1])))
      }

    return Robot(
      position: parts[0].1,
      velocity: parts[1].1
    )
  }

  func moveRobot(_ robot: Robot) -> Robot {
    let newX = (((robot.position.x + robot.velocity.vx) % self.width) + self.width) % self.width
    let newY = (((robot.position.y + robot.velocity.vy) % self.height) + self.height) % self.height

    return Robot(
      position: (x: newX, y: newY),
      velocity: robot.velocity
    )
  }

  func simulateSteps(_ stepCount: Int, robots: [Robot]) -> [Robot] {
    return robots.map { robot in
      (0..<stepCount).reduce(robot) { currentRobot, _ in
        moveRobot(currentRobot)
      }
    }
  }

  func getQuadrant(robot: Robot) -> Int? {
    let midX = self.width / 2
    let midY = self.height / 2

    if robot.position.x == midX || robot.position.y == midY {
      return nil
    }

    switch (robot.position.x < midX, robot.position.y < midY) {
    case (true, true): return 0  // Top left
    case (false, true): return 1  // Top right
    case (true, false): return 2  // Bottom left
    case (false, false): return 3  // Bottom right
    }
  }

  // Solution for the first part of the day's challenge.
  func part1() -> Any {
    let finalPositions = simulateSteps(100, robots: robots)

    var quadrantCounts = [0, 0, 0, 0]
    for robot in finalPositions {
      if let quadrant = getQuadrant(robot: robot) {
        quadrantCounts[quadrant] += 1
      }
    }

    return quadrantCounts.reduce(1, *)
  }

  // Solution for the second part of the day's challenge.
  func part2() -> Any {
    return 0
  }
}
