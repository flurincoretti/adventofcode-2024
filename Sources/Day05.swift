//
//  Day05.swift
//  AdventOfCode
//
//  Created by Flurin Coretti on 07.12.2024.
//

import Algorithms

struct Rule {
  let before: Int
  let after: Int
}

struct Update {
  let pages: [Int]
}

struct Day05: AdventDay {
  var data: String
  let rules: [Rule]
  let updates: [Update]

  // Read the inputs.
  init(data: String) {
    self.data = data

    let sections = data.split(separator: "\n\n")

    // Parse rules.
    self.rules = sections[0].split(separator: "\n").map { line in
      let parts = line.split(separator: "|").map { Int($0)! }
      return Rule(before: parts[0], after: parts[1])
    }

    // Parse updates.
    self.updates = sections[1].split(separator: "\n").map { line in
      let pages = line.split(separator: ",").map { Int($0)! }
      return Update(pages: pages)
    }
  }

  func followsOrderingRules(_ update: Update) -> Bool {
    for rule in rules {
      let beforeExists = update.pages.contains(rule.before)
      let afterExists = update.pages.contains(rule.after)

      if beforeExists && afterExists {
        let beforeIndex = update.pages.firstIndex(of: rule.before)
        let afterIndex = update.pages.firstIndex(of: rule.after)

        if beforeIndex! > afterIndex! {
          return false
        }
      }
    }
    return true
  }

  func fixPageOrderViolations(_ update: Update) -> Update {
    var pages = update.pages
    var madeSwap: Bool

    repeat {
      madeSwap = false
      for i in 0..<(pages.count - 1) {
        let page1 = pages[i]
        let page2 = pages[i + 1]
        if rules.contains(where: { $0.before == page2 && $0.after == page1 }) {
          pages.swapAt(i, i + 1)
          madeSwap = true
        }
      }
    } while madeSwap
    return Update(pages: pages)
  }

  // Solution for the first part of the day's challenge.
  func part1() -> Any {
    let validUpdates = updates.filter { followsOrderingRules($0) }

    return validUpdates.map { update in
      let middleIndex = update.pages.count / 2
      return update.pages[middleIndex]
    }.reduce(0, +)
  }

  // Solution for the second part of the day's challenge.
  func part2() -> Any {
    let invalidUpdates = updates.filter { !followsOrderingRules($0) }

    let sortedUpdates = invalidUpdates.map { update in
      fixPageOrderViolations(update)
    }

    return sortedUpdates.map { update in
      let middleIndex = update.pages.count / 2
      return update.pages[middleIndex]
    }.reduce(0, +)
  }
}
