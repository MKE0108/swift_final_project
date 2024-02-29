import SwiftUI

///
/// @AppStorage cannot use with @Published. That's why objectWillChange.send() are being
/// added manually in the setter.
///
class UserSettingsModel : ObservableObject {
    @AppStorage("useVibration") var useVibration = false
    @AppStorage("appUserLanguage") var appUserLang: Int = AppUserLanguage.tw_ch.rawValue
    @AppStorage("lightingMode") var useDarkMode: Bool = false

    @AppStorage("limitValue") var limitValue: Int = 10
    
    var limitValuePublished: Int {
        get{limitValue}
        set {
            limitValue = newValue
            objectWillChange.send()
        }
    }
    
    var appUserLangPublished: Int {
        get {appUserLang}
        set {
            appUserLang = newValue
            objectWillChange.send()
        }
    }
    var useVibrationPublished: Bool {
        get {useVibration}
        set {
            useVibration = newValue
            objectWillChange.send()
        }
    }
    var useDarkModePublished: Bool {
        get {useDarkMode}
        set {
            useDarkMode = newValue
            objectWillChange.send()
        }
    }
}
