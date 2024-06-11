class TreeNode {
    var val: Int
    var left: TreeNode?
    var right: TreeNode?
    
    init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
}

func levelOrder(_ root: TreeNode?) -> [[Int]] {
    guard let root = root else {
        return []
    }
    
    var result: [[Int]] = []
    var queue: [TreeNode] = [root]
    
    while !queue.isEmpty {
        let size = queue.count
        var level: [Int] = []
        
        for _ in 0..<size {
            let node = queue.removeFirst()
            level.append(node.val)
            
            if let left = node.left {
                queue.append(left)
            }
            if let right = node.right {
                queue.append(right)
            }
        }
        
        result.append(level)
    }
    
    return result
}

let root = TreeNode(1)
root.left = TreeNode(2)
root.right = TreeNode(3)
root.left?.left = TreeNode(4)
root.left?.right = TreeNode(5)
root.right?.right = TreeNode(6)

let levels = levelOrder(root)
print(levels) // 输出：[[1], [2, 3], [4, 5, 6]]
