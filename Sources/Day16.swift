//
//  Day16.swift
//  AdventOfCode
//
//  Created by Flurin Coretti on 20.12.2024.
//

import Algorithms

private class MinHeap<Element: Comparable> {
  private var heap: [Element]

  init() {
    self.heap = []
  }

  init(array: [Element]) {
    self.heap = array
    heapify()
  }

  var isEmpty: Bool {
    return heap.isEmpty
  }

  var count: Int {
    return heap.count
  }

  private func getParentIndex(of index: Int) -> Int {
    return (index - 1) / 2
  }

  private func getLeftChildIndex(of index: Int) -> Int {
    return 2 * index + 1
  }

  private func getRightChildIndex(of index: Int) -> Int {
    return 2 * index + 2
  }

  private func hasLeftChild(at index: Int) -> Bool {
    return getLeftChildIndex(of: index) < heap.count
  }

  private func hasRightChild(at index: Int) -> Bool {
    return getRightChildIndex(of: index) < heap.count
  }

  private func getParent(of index: Int) -> Element {
    return heap[getParentIndex(of: index)]
  }

  private func getLeftChild(of index: Int) -> Element {
    return heap[getLeftChildIndex(of: index)]
  }

  private func getRightChild(of index: Int) -> Element {
    return heap[getRightChildIndex(of: index)]
  }

  private func siftUp(from index: Int) {
    var childIndex = index
    var parentIndex = getParentIndex(of: childIndex)

    while childIndex > 0 && heap[childIndex] < heap[parentIndex] {
      heap.swapAt(childIndex, parentIndex)
      childIndex = parentIndex
      parentIndex = getParentIndex(of: childIndex)
    }
  }

  private func siftDown(from index: Int) {
    var parentIndex = index

    while hasLeftChild(at: parentIndex) {
      var smallestChildIndex = getLeftChildIndex(of: parentIndex)

      if hasRightChild(at: parentIndex)
        && getRightChild(of: parentIndex) < getLeftChild(of: parentIndex)
      {
        smallestChildIndex = getRightChildIndex(of: parentIndex)
      }

      if heap[parentIndex] <= heap[smallestChildIndex] {
        break
      }

      heap.swapAt(parentIndex, smallestChildIndex)
      parentIndex = smallestChildIndex
    }
  }

  private func heapify() {
    let lastParentIndex = getParentIndex(of: heap.count - 1)
    for index in stride(from: lastParentIndex, through: 0, by: -1) {
      siftDown(from: index)
    }
  }

  func peek() -> Element? {
    return heap.first
  }

  func insert(_ element: Element) {
    heap.append(element)
    siftUp(from: heap.count - 1)
  }

  func remove() -> Element? {
    guard !heap.isEmpty else { return nil }

    if heap.count == 1 {
      return heap.removeFirst()
    }

    let min = heap[0]
    heap[0] = heap.removeLast()
    siftDown(from: 0)
    return min
  }
}

private class PriorityQueue<Element: Comparable> {
  private var heap: MinHeap<Element>

  init() {
    self.heap = MinHeap<Element>()
  }

  init(array: [Element]) {
    self.heap = MinHeap(array: array)
  }

  var isEmpty: Bool {
    return heap.isEmpty
  }

  var count: Int {
    return heap.count
  }

  func peek() -> Element? {
    return heap.peek()
  }

  func enqueue(_ element: Element) {
    heap.insert(element)
  }

  func dequeue() -> Element? {
    return heap.remove()
  }
}

struct Day16: AdventDay {
  var grid: [[Character]]

  var startPosition: Position {
    for row in grid.indices {
      for col in grid[row].indices {
        if grid[row][col] == "S" {
          return Position(row: row, col: col)
        }
      }
    }
    fatalError("No start position found")
  }

  var endPosition: Position {
    for row in grid.indices {
      for col in grid[row].indices {
        if grid[row][col] == "E" {
          return Position(row: row, col: col)
        }
      }
    }
    fatalError("No end position found")
  }

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

    func turnLeft() -> Direction {
      switch self {
      case .up: return .left
      case .right: return .up
      case .down: return .right
      case .left: return .down
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

  struct State: Hashable {
    var position: Position
    var direction: Direction
  }

  struct WeightedState: Comparable {
    let state: State
    let cost: Int

    static func < (lhs: WeightedState, rhs: WeightedState) -> Bool {
      return lhs.cost < rhs.cost
    }

    static func == (lhs: WeightedState, rhs: WeightedState) -> Bool {
      return lhs.cost == rhs.cost && lhs.state == rhs.state
    }
  }

  private func getNextPosition(from current: Position, facing direction: Direction) -> Position {
    let vector = direction.vector
    return Position(
      row: current.row + vector.row,
      col: current.col + vector.col
    )
  }

  private func isValidPosition(_ position: Position) -> Bool {
    guard
      position.row >= 0 && position.row < grid.count && position.col >= 0
        && position.col < grid[0].count
    else {
      return false
    }
    return grid[position.row][position.col] != "#"
  }

  // Read the inputs.
  init(data: String) {
    self.grid = data.split(separator: "\n").map { line in
      line.compactMap { $0 }
    }
  }

  // Solution for the first part of the day's challenge.
  func part1() -> Any {
    let queue = PriorityQueue<WeightedState>()
    var costs = [State: Int]()

    let initialState = State(position: startPosition, direction: .right)
    costs[initialState] = 0
    queue.enqueue(WeightedState(state: initialState, cost: 0))

    while !queue.isEmpty {
      guard let current = queue.dequeue() else { continue }

      if let knownCost = costs[current.state], knownCost < current.cost {
        continue
      }

      if current.state.position == endPosition {
        return current.cost
      }

      let nextPosition = getNextPosition(
        from: current.state.position, facing: current.state.direction)
      if isValidPosition(nextPosition) {
        let nextState = State(position: nextPosition, direction: current.state.direction)
        let nextCost = current.cost + 1

        if nextCost < (costs[nextState] ?? Int.max) {
          costs[nextState] = nextCost
          queue.enqueue(WeightedState(state: nextState, cost: nextCost))
        }
      }

      for newDirection in [current.state.direction.turnLeft(), current.state.direction.turnRight()]
      {
        let nextPosition = getNextPosition(from: current.state.position, facing: newDirection)

        if isValidPosition(nextPosition) {
          let nextState = State(position: nextPosition, direction: newDirection)
          let nextCost = current.cost + 1001

          if nextCost < (costs[nextState] ?? Int.max) {
            costs[nextState] = nextCost
            queue.enqueue(WeightedState(state: nextState, cost: nextCost))
          }
        }
      }
    }

    return "No path found"
  }

  // Solution for the second part of the day's challenge.
  func part2() -> Any {
    return 0
  }
}
