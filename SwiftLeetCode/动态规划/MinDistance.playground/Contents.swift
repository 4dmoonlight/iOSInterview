/*
 要计算将字符串 a 转换为字符串 b 需要的最小变更次数（包括插入、删除和替换操作），可以使用动态规划算法。这种算法也被称为编辑距离（Edit Distance）或莱文斯坦距离（Levenshtein Distance）。


 动态规划算法步骤
 定义状态：

 创建一个二维数组 dp，其中 dp[i][j] 表示将字符串 a 的前 i 个字符转换为字符串 b 的前 j 个字符所需的最小编辑次数。
 初始化状态：

 dp[0][0] 为 0，表示将空字符串转换为空字符串的编辑距离为 0。
 dp[i][0] 为 i，表示将字符串 a 的前 i 个字符转换为空字符串所需的编辑距离为 i（删除 i 个字符）。
 dp[0][j] 为 j，表示将空字符串转换为字符串 b 的前 j 个字符所需的编辑距离为 j（插入 j 个字符）。
 状态转移：

 如果 a[i-1] == b[j-1]，则 dp[i][j] = dp[i-1][j-1]，表示字符相同，不需要额外操作。
 否则，取以下三种情况的最小值加 1：
 替换操作：dp[i-1][j-1] + 1
 插入操作：dp[i][j-1] + 1
 删除操作：dp[i-1][j] + 1
 结果：

 最终结果存储在 dp[m][n]，其中 m 是字符串 a 的长度，n 是字符串 b 的长度。
 */
func minDistance(_ word1: String, _ word2: String) -> Int {
    let m = word1.count
    let n = word2.count
    let word1Array = Array(word1)
    let word2Array = Array(word2)

    // 创建 dp 数组
    var dp = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)

    // 初始化 dp 数组
    for i in 0...m {
        dp[i][0] = i
    }
    for j in 0...n {
        dp[0][j] = j
    }

    // 填充 dp 数组
    for i in 1...m {
        for j in 1...n {
            if word1Array[i - 1] == word2Array[j - 1] {
                dp[i][j] = dp[i - 1][j - 1]
            } else {
                dp[i][j] = min(dp[i - 1][j - 1], min(dp[i][j - 1], dp[i - 1][j])) + 1
            }
        }
    }

    return dp[m][n]
}

// 示例用法
let a = "kitten"
let b = "sitting"
print("Minimum operations required: \(minDistance(a, b))")
