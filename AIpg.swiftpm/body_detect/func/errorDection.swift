import SwiftUI

func ThreeKPSangle(A:Keypoint ,B:Keypoint ,C:Keypoint ) -> CGFloat{
    let A = Point(x: CGFloat(A.x), y: CGFloat(A.y))
    let B = Point(x: CGFloat(B.x), y: CGFloat(B.y))
    let C = Point(x: CGFloat(C.x), y: CGFloat(C.y))
    
    let BA = vector(from: B, to: A)
    let BC = vector(from: B, to: C)
    return angleBetweenVectors(BA, BC)
}



func getTargetDegree(kp:[Keypoint])->CGFloat{
    if(kp[2].v>=keypointThreshold && kp[4].v>=keypointThreshold && kp[6].v>=keypointThreshold){
        //var angle = ThreeKPSangle(A: kp[2], B: kp[4], C: kp[6])
        var tmp = kp[6]
        tmp.x *= 2;
        return ThreeKPSangle(A: tmp, B: kp[6], C: kp[4])
        
    }else if(kp[1].v>=keypointThreshold && kp[3].v>=keypointThreshold && kp[5].v>=keypointThreshold){
        //var angle = ThreeKPSangle(A: kp[1], B: kp[3], C: kp[5])
        var tmp = kp[5]
        tmp.x /= 2;
        return ThreeKPSangle(A: tmp, B: kp[5], C: kp[3])
    }else{
        return -1
    }
}
func checkTurnAround(kp:[Keypoint])->Int{
    if (kp.isEmpty){ return -1}
    if(kp[6].v>=keypointThreshold && kp[5].v>=keypointThreshold){
        if(kp[3].v>=keypointThreshold || kp[4].v>=keypointThreshold||kp[2].v>=keypointThreshold || kp[1].v>=keypointThreshold) {
            if(kp[3].v>=keypointThreshold && kp[4].v>=keypointThreshold) {
                return 1
            }
        }
    }
    return 0
}



func check(kp:[Keypoint],threshold:CGFloat)->Int{
    let tmp = checkTurnAround(kp: kp)
    if(tmp == 1){
        return 2
    }else if(tmp == -1){
        return -1
    }
    var angle = (getTargetDegree(kp: kp))
    return angle == -1 ? Int(angle) : (angle < threshold * 0.8 ? 1 : 0)
}
