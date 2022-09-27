// Based on https://github.com/raywenderlich/swift-algorithm-club/tree/master/Kth%20Largest%20Element
extension Array where Element: Comparable {
  /// Returns the k-th largest element from the array.
  ///
  /// This works a bit like quicksort and a bit like binary search.
  /// The partitioning step picks a random pivot and uses Lomuto's scheme to
  /// rearrange the array; afterwards, this pivot is in its final sorted position.
  /// If this pivot index equals i, we're done. If i is larger, then we continue
  /// with the left side, otherwise we continue with the right side.
  ///
  /// - Complexity: O(n) if the elements are distinct.
  public func max(k: Index) -> Element {
    precondition(!isEmpty)
    precondition(k < count)
    var array = self
    return array.randomizedSelect(low: 0, high: array.count - 1, k: k)
  }

  private mutating func randomPivot(low: Index, high: Index) -> Element {
    let pivotIndex = Index.random(in: low...high)
    swapAt(pivotIndex, high)
    return self[high]
  }

  private mutating func randomizedPartition(low: Index, high: Index) -> Index {
    let pivot = randomPivot(low: low, high: high)
    var i = low
    for j in low..<high {
      if self[j] > pivot {
        swapAt(i, j)
        i += 1
      }
    }
    swapAt(i, high)
    return i
  }

  private mutating func randomizedSelect(low: Index, high: Index, k: Index) -> Element {
    if low < high {
      let partition = randomizedPartition(low: low, high: high)
      if k == partition {
        return self[partition]
      } else if k < partition {
        return randomizedSelect(low: low, high: partition - 1, k: k)
      } else {
        return randomizedSelect(low: partition + 1, high: high, k: k)
      }
    } else {
      return self[low]
    }
  }
}
