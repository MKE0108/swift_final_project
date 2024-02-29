import SwiftUI

///
/// Add functionalities to setup RGB color through 0~255 instead of 0.0 ~ 1.0.
/// Just remember to pass integer value for this to work.
///
extension Color {
    init(red: Int, green: Int, blue: Int, alpha: Double = 1.0) {
        self.init(red: Double(red) / 255.0, green: Double(green) / 255.0, blue: Double(blue) / 255.0, opacity: alpha)
    }
}
