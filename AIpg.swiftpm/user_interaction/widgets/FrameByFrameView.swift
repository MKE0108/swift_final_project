import Foundation
import SwiftUI

struct FrameByFrameView: View {
    
    @State var currentFrameName: String = ""
    @State var timer: Timer?
    
    var framePrefix = ""
    
    let endFrame: Int
    let frameInterval: Double
    let shouldRepeat: Bool
    
    
    init(currentFrameName: String, endFrame: Int, frameInterval: Double, shouldRepeat: Bool) {
        self.currentFrameName = "\(currentFrameName)\(0)"
        self.framePrefix = currentFrameName
        self.endFrame = endFrame
        self.frameInterval = frameInterval
        self.shouldRepeat = shouldRepeat
    }
    
    var body: some View {
        Image(currentFrameName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onAppear(perform: timerUpdate)
    }
    
    func timerUpdate() {
        
        var currentIndex: Int = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: frameInterval, repeats: true) { (Timer) in
            currentFrameName = "\(framePrefix)\(currentIndex)"
//            print("Frame name: \(currentFrameName)")
            currentIndex = (currentIndex + 1) % (endFrame + 1)
            if (!shouldRepeat && currentIndex == 0) {
                stopTimer()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
