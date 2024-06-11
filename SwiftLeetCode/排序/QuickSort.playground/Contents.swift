import UIKit

// 递归
func quickSort<T: Comparable>(_ arr: inout [T], low: Int, high: Int) {
    if low < high {
        let pivotIndex = partition(&arr, low: low, high: high)
        print(arr)
        quickSort(&arr, low: low, high: pivotIndex - 1)
        quickSort(&arr, low: pivotIndex + 1, high: high)
    }
}

func partition<T: Comparable>(_ arr: inout [T], low: Int, high: Int) -> Int {
    let pivot = arr[high]
    var i = low
    for j in low..<high {
        if arr[j] <= pivot {
            arr.swapAt(i, j)
            i += 1
        }
    }
    
    arr.swapAt(i, high)
    return i
}

var numbers = [3, 6, 8, 7, 1, 2, 5, 4]
quickSort(&numbers, low: 0, high: numbers.count - 1)

