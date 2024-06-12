import UIKit

// 递归方法
func binarySearch<T: Comparable>(_ arr: [T], target: T, low: Int, high: Int) -> Int? {
    if low > high {
        return nil  // 未找到目标
    }
    
    let mid = low + (high - low) / 2
    if arr[mid] == target {
        return mid  // 找到目标，返回索引
    } else if arr[mid] < target {
        return binarySearch(arr, target: target, low: mid + 1, high: high)  // 目标在右侧
    } else {
        return binarySearch(arr, target: target, low: low, high: mid - 1)  // 目标在左侧
    }
}

// 非递归方法
func binarySearch<T: Comparable>(_ arr: [T], target: T) -> Int? {
    var low = 0
    var high = arr.count - 1
    
    while low <= high {
        let mid = low + (high - low) / 2
        if arr[mid] == target {
            return mid  // 找到目标，返回索引
        } else if arr[mid] < target {
            low = mid + 1  // 目标在右侧
        } else {
            high = mid - 1  // 目标在左侧
        }
    }
    
    return nil  // 未找到目标
}

let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
let target = 7

// 调用非递归方法
if let index = binarySearch(numbers, target: target) {
    print("Found \(target) at index \(index)")
} else {
    print("\(target) not found")
}

// 调用递归方法
if let index = binarySearch(numbers, target: target, low: 0, high: numbers.count - 1) {
    print("Found \(target) at index \(index)")
} else {
    print("\(target) not found")
}

// 扩展问题：
// Q：递归方法什么情况下不建议使用
// A：处理大数据集时不建议，会导致栈溢出
