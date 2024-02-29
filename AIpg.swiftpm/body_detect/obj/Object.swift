import SwiftUI

class SharedData: ObservableObject {
    @Published var KPS: [Keypoint]=[]
    @Published var KeyPointThreshold:Float
    @Published var useFrontCamera: Bool = true
    init(keyPointThreshold: Float = 0.45) {
        self.KeyPointThreshold = keyPointThreshold
    }
    // 你可以添加任何其他需要共享的属性
}

struct Keypoint {
    var x: Float
    var y: Float
    var v: Float
    init(x: Float, y: Float, v: Float) {
        self.x = x
        self.y = y
        self.v = v
    }
}

// 定义检测框结构体
struct Detection {
    var keypoints: [Keypoint] // 关键点数组
    init?(data: [Float]) {
        guard data.count == 51 else { return nil }
        
        // 提取关键点信息
        var keypoints = [Keypoint]()
        for i in stride(from: 0, to: data.count, by: 3) {
            let keypoint = Keypoint(x: data[i+1], y: data[i+0], v: data[i+2])
            keypoints.append(keypoint)
        }
        
        self.keypoints = keypoints
    }
}
