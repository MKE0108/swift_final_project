import SwiftUI

enum AppUserLanguage : Int {
    case tw_ch  = 0
    case en_us  = 1
    case latin  = 2
    case jap    = 3
    case viet   = 4
    case korean = 5
    case none   = -1
    
    var description: String {
        switch self {
        case .tw_ch: return "中文"
        case .en_us: return "English"
        case .latin: return "Lingua Latina"
        case .jap: return "日本語"
        case .viet: return "Tiếng Việt"
        case .korean: return "한국어"
        case .none: return "NONE"
        }
    }
}
