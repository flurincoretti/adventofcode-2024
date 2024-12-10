//
//  Day08.swift
//  AdventOfCode
//
//  Created by Flurin Coretti on 10.12.2024.
//

import Algorithms

struct Point: Hashable {
  let x: Int
  let y: Int

  func isWithinBounds(width: Int, height: Int) -> Bool {
    x >= 0 && x < width && y >= 0 && y < height
  }

  func distanceSquared(to other: Point) -> Int {
    let dx = x - other.x
    let dy = y - other.y
    return dx * dx + dy * dy
  }
}

struct Antenna {
  let position: Point
  let frequency: Character
}

struct Day08: AdventDay {
  let antennas: [Antenna]
  let width: Int
  let height: Int

  // Read the inputs.
  init(data: String) {
    let lines = data.split(separator: "\n")
    height = lines.count
    width = lines[0].count

    var tempAntennas: [Antenna] = []
    for (y, line) in lines.enumerated() {
      for (x, char) in line.enumerated() {
        if char != "." {
          tempAntennas.append(Antenna(position: Point(x: x, y: y), frequency: char))
        }
      }
    }
    antennas = tempAntennas
  }

  // Group antennas by their frequency.
  func antennasByFrequency() -> [Character: [Antenna]] {
    Dictionary(grouping: antennas, by: { $0.frequency })
  }

  // Find all pairs of antennas of the same frequency.
  func findSameFrequencyPairs() -> [(Antenna, Antenna)] {
    var pairs: [(Antenna, Antenna)] = []
    let groups = antennasByFrequency()

    for antennas in groups.values {
      if antennas.count >= 2 {
        for i in 0..<antennas.count {
          for j in (i + 1)..<antennas.count {
            pairs.append((antennas[i], antennas[j]))
          }
        }
      }
    }

    return pairs
  }

  // Find antinodes.
  func findAntinodes(antenna1: Antenna, antenna2: Antenna) -> Set<Point> {
    var antinodes = Set<Point>()

    let dx = antenna2.position.x - antenna1.position.x
    let dy = antenna2.position.y - antenna1.position.y

    let antinode1 = Point(
      x: antenna1.position.x - dx,
      y: antenna1.position.y - dy
    )

    let antinode2 = Point(
      x: antenna2.position.x + dx,
      y: antenna2.position.y + dy
    )

    if antinode1.isWithinBounds(width: width, height: height) {
      antinodes.insert(antinode1)
    }

    if antinode2.isWithinBounds(width: width, height: height) {
      antinodes.insert(antinode2)
    }

    return antinodes
  }

  // Find collinear points.
  func findCollinearPoints(antenna1: Antenna, antenna2: Antenna) -> Set<Point> {
    var points = Set<Point>()

    let dx = antenna2.position.x - antenna1.position.x
    let dy = antenna2.position.y - antenna1.position.y

    points.insert(antenna1.position)
    points.insert(antenna2.position)

    // Go backwards from antenna1.
    var x = antenna1.position.x - dx
    var y = antenna1.position.y - dy
    while Point(x: x, y: y).isWithinBounds(width: width, height: height) {
      points.insert(Point(x: x, y: y))
      x -= dx
      y -= dy
    }

    // Go forwards from antenna2.
    x = antenna2.position.x + dx
    y = antenna2.position.y + dy
    while Point(x: x, y: y).isWithinBounds(width: width, height: height) {
      points.insert(Point(x: x, y: y))
      x += dx
      y += dy
    }

    return points
  }

  // Solution for the first part of the day's challenge.
  func part1() -> Any {
    let pairs = findSameFrequencyPairs()
    var allAntinodes = Set<Point>()

    for (antenna1, antenna2) in pairs {
      let antinodes = findAntinodes(antenna1: antenna1, antenna2: antenna2)
      allAntinodes.formUnion(antinodes)
    }

    return allAntinodes.count
  }

  // Solution for the second part of the day's challenge.
  func part2() -> Any {
    let pairs = findSameFrequencyPairs()
    var allAntinodes = Set<Point>()

    for (antenna1, antenna2) in pairs {
      let antinodes = findCollinearPoints(antenna1: antenna1, antenna2: antenna2)
      allAntinodes.formUnion(antinodes)
    }

    return allAntinodes.count
  }
}
