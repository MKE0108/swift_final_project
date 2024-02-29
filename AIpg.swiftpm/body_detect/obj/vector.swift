import SwiftUI


func distanceBetween(v1: Point, v2: Point) -> Double {
    let differenceVector = Point(x: v1.x - v2.x, y: v1.y - v2.y)
    return sqrt(differenceVector.x * differenceVector.x + differenceVector.y * differenceVector.y)
}

struct Point {
    var x: CGFloat
    var y: CGFloat
}

// 计算两点之间的向量
func vector(from point1: Point, to point2: Point) -> Point {
    return Point(x: point2.x - point1.x, y: point2.y - point1.y)
}

// 计算向量的模
func magnitude(of vector: Point) -> CGFloat {
    return sqrt(vector.x * vector.x + vector.y * vector.y)
}

// 计算两个向量的点积
func dotProduct(_ vector1: Point, _ vector2: Point) -> CGFloat {
    return vector1.x * vector2.x + vector1.y * vector2.y
}

// 计算两个向量之间的角度
func angleBetweenVectors(_ vector1: Point, _ vector2: Point) -> CGFloat {
    let dotProd = dotProduct(vector1, vector2)
    let magVector1 = magnitude(of: vector1)
    let magVector2 = magnitude(of: vector2)
    return acos(dotProd / (magVector1 * magVector2)) * (180 / .pi) // 转换为度
}
