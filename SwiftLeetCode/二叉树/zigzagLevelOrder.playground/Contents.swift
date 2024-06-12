import Foundation
// 字节跳动 算法题
// 二叉树 一层正序一层倒序遍历
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

func zigzagLevelOrder(_ root: TreeNode?) -> [[Int]] {
    guard let root = root else { return [] }
    
    var result: [[Int]] = []
    var queue: [TreeNode] = [root]
    var leftToRight = true
    
    while !queue.isEmpty {
        var level: [Int] = []
        let size = queue.count
        
        for _ in 0..<size {
            let node = queue.removeFirst()
            if leftToRight {
                level.append(node.val)
            } else {
                level.insert(node.val, at: 0)
            }
            
            if let leftNode = node.left {
                queue.append(leftNode)
            }
            if let rightNode = node.right {
                queue.append(rightNode)
            }
        }
        
        result.append(level)
        leftToRight.toggle()
    }
    
    return result
}

// Helper function to create a binary tree for testing
func createBinaryTree() -> TreeNode {
    let root = TreeNode(1)
    root.left = TreeNode(2)
    root.right = TreeNode(3)
    root.left?.left = TreeNode(4)
    root.left?.right = TreeNode(5)
    root.right?.left = TreeNode(6)
    root.right?.right = TreeNode(7)
    return root
}

// Example usage
let root = createBinaryTree()
let result = zigzagLevelOrder(root)
for level in result {
    print(level)
}
