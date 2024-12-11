//
//  Day09.swift
//  AdventOfCode
//
//  Created by Flurin Coretti on 11.12.2024.
//

import Algorithms

struct Day09: AdventDay {
  let diskState: [Int?]

  // Read the inputs.
  init(data: String) {
    let numbers = data.compactMap { $0.wholeNumberValue }

    let state = numbers.enumerated().map { index, length -> [Int?] in
      if index.isMultiple(of: 2) {
        return Array(repeating: index / 2, count: length)
      } else {
        return Array(repeating: nil, count: length)
      }
    }

    diskState = state.flatMap { $0 }
  }

  // Solution for the first part of the day's challenge.
  func part1() -> Any {
    var state = diskState

    var leftIndex = 0
    var rightIndex = state.count - 1

    while leftIndex < rightIndex {
      while rightIndex > 0 && state[rightIndex] == nil {
        rightIndex -= 1
      }

      while leftIndex < state.count && state[leftIndex] != nil {
        leftIndex += 1
      }

      if rightIndex <= leftIndex {
        break
      }

      state[leftIndex] = state[rightIndex]
      state[rightIndex] = nil
    }

    return state.enumerated().reduce(0) { sum, pair in
      let (position, fileId) = pair
      return sum + (fileId ?? 0) * position
    }
  }

  // Solution for the second part of the day's challenge.
  func part2() -> Any {
    var state = diskState

    var rightIndex = state.count - 1

    while rightIndex > 0 {
      while rightIndex > 0 && state[rightIndex] == nil {
        rightIndex -= 1
      }

      // Count the length of the rightmost file.
      let fileId = state[rightIndex]
      var fileLength = 0
      var temp = rightIndex
      while temp >= 0 && state[temp] == fileId {
        fileLength += 1
        temp -= 1
      }

      // Find leftmost free space big enough for this file
      var spaceStart = 0
      var freeLength = 0
      while spaceStart + freeLength < rightIndex {
        if state[spaceStart + freeLength] == nil {
          freeLength += 1
          if freeLength >= fileLength {
            break
          }
        } else {
          spaceStart += freeLength + 1
          freeLength = 0
        }
      }

      // Move file if we found enough space.
      if freeLength >= fileLength && spaceStart < temp {
        for i in 0..<fileLength {
          state[spaceStart + i] = fileId
          state[rightIndex - i] = nil
        }
      }
      rightIndex = temp
    }

    return state.enumerated().reduce(0) { sum, pair in
      let (position, fileId) = pair
      return sum + (fileId ?? 0) * position
    }
  }
}
