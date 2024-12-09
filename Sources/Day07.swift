//
//  Day07.swift
//  AdventOfCode
//
//  Created by Flurin Coretti on 09.12.2024.
//

import Algorithms

struct Equation {
  let testValue: Int
  let numbers: [Int]

  static func parse(_ input: String) -> [Equation] {
    input.split(separator: "\n").compactMap { line in
      let parts = line.split(separator: ":")
      let testValue = Int(parts[0].trimmingCharacters(in: .whitespaces))!
      let numbers = parts[1].split(separator: " ")
        .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
      return Equation(testValue: testValue, numbers: numbers)
    }
  }

  func evaluate(operators: [String]) -> Int {
    var result = numbers[0]

    for i in 0..<operators.count {
      let nextNum = numbers[i + 1]
      switch operators[i] {
      case "+": result += nextNum
      case "*": result *= nextNum
      case "||": result = Int(String(result) + String(nextNum))!
      default: fatalError("Unknown operator")
      }
    }

    return result
  }

  func generateOperatorCombinations(count: Int, using operators: [String]) -> [[String]] {
    var result: [[String]] = [[]]

    for _ in 0..<count {
      result = Array(product(result, operators).map { $0.0 + [$0.1] })
    }

    return result
  }

  func canBeSolved(using operators: [String]) -> Bool {
    let operatorCount = numbers.count - 1
    let operatorCombinations = generateOperatorCombinations(count: operatorCount, using: operators)

    return operatorCombinations.contains { operators in
      evaluate(operators: operators) == testValue
    }
  }
}

struct Day07: AdventDay {
  var equations: [Equation]

  // Read the inputs.
  init(data: String) {
    self.equations = Equation.parse(data)
  }

  // Solution for the first part of the day's challenge.
  func part1() -> Any {
    let operators = ["+", "*"]
    return
      equations
      .filter { $0.canBeSolved(using: operators) }
      .map { $0.testValue }
      .reduce(0, +)
  }

  // Solution for the second part of the day's challenge.
  func part2() -> Any {
    let operators = ["+", "*", "||"]
    return
      equations
      .filter { $0.canBeSolved(using: operators) }
      .map { $0.testValue }
      .reduce(0, +)
  }
}
