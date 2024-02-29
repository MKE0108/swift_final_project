
import SwiftUI

///
/// .onAppear() gets called only once for a view, not on each re-render.
/// That makes it good for updating state object (in this case, lingual) for the first time.
///
struct ContentView: View {
    @StateObject var userSettings = UserSettingsModel()
    @StateObject var lingual = LingualModel() 
    @State var LoginSucess = false
    
    var body: some View {
        mainContent()
    }
    
    func mainContent() -> some View {
        var colorScheme: ColorScheme
        if userSettings.useDarkMode {
            colorScheme = .dark
        } else {
            colorScheme = .light
        }
        
        return ZStack{
            if LoginSucess {
                MainView(userSettings: userSettings, lingual: lingual)
            } else {
                LoginView(LoginSucess: self.$LoginSucess, lingual: lingual, userSettings: userSettings)
            }
        }
        .onAppear(perform: {
            updateLingual()
        })
        .onReceive(userSettings.objectWillChange, perform: {
            print("Language changing to: \(userSettings.appUserLang)...")
            updateLingual()
        })
        .preferredColorScheme(colorScheme)
    }
    
    func updateLingual() -> Void {
        
        var langsData: [LangSpecificUIString]? = {
            switch AppUserLanguage(rawValue: userSettings.appUserLang) {
            case .tw_ch:
                return loadJsonFile("tw_ch_string.json")
            case .en_us:
                return loadJsonFile("en_us_string.json")
            case .latin:
                return loadJsonFile("latin_string.json")
            case .jap:
                return loadJsonFile("jap_string.json")
            case .viet:
                return loadJsonFile("vietnamese_string.json")
            case .korean:
                return loadJsonFile("korean_string.json")
            default:
                return nil
            }
        }()
        lingual.appTitle = findContentByTitle(langData: &langsData!, title: "app_title") ?? lingual.appTitle
        
        lingual.tabMonitor = findContentByTitle(langData: &langsData!, title: "tab_monitor") ?? lingual.tabMonitor
        lingual.tabData = findContentByTitle(langData: &langsData!, title: "tab_data") ?? lingual.tabData
        lingual.tabUser = findContentByTitle(langData: &langsData!, title: "tab_user") ?? lingual.tabUser
        lingual.tabSettings = findContentByTitle(langData: &langsData!, title: "tab_settings") ?? lingual.tabSettings
        
        lingual.login = findContentByTitle(langData: &langsData!, title: "login") ?? lingual.login
        lingual.account = findContentByTitle(langData: &langsData!, title: "account") ?? lingual.account
        lingual.password = findContentByTitle(langData: &langsData!, title: "password") ?? lingual.password
        lingual.signUp = findContentByTitle(langData: &langsData!, title: "signup") ?? lingual.signUp
        lingual.register = findContentByTitle(langData: &langsData!, title: "register") ?? lingual.register
        
        lingual.detectionMode = findContentByTitle(langData: &langsData!, title: "detection_mode") ?? lingual.detectionMode
        lingual.correctionMode = findContentByTitle(langData: &langsData!, title: "correction_mode") ?? lingual.correctionMode
        lingual.noTarget = findContentByTitle(langData: &langsData!, title: "no_target") ?? lingual.noTarget
        lingual.correction = findContentByTitle(langData: &langsData!, title: "correction") ?? lingual.correction
        lingual.afterSecs = findContentByTitle(langData: &langsData!, title: "after_secs") ?? lingual.afterSecs
        lingual.leftover = findContentByTitle(langData: &langsData!, title: "leftover") ?? lingual.leftover
        lingual.second = findContentByTitle(langData: &langsData!, title: "second") ?? lingual.second
        lingual.sideways = findContentByTitle(langData: &langsData!, title: "sideways") ?? lingual.sideways
        lingual.hunchback = findContentByTitle(langData: &langsData!, title: "hunchback") ?? lingual.hunchback
        lingual.idle = findContentByTitle(langData: &langsData!, title: "idle") ?? lingual.idle
        
        lingual.useVibrationWhenDetectHunchback = findContentByTitle(langData: &langsData!, title: "useVibrationWhenDetectHunchback") ?? lingual.useVibrationWhenDetectHunchback
        lingual.selectLanguage = findContentByTitle(langData: &langsData!, title: "selectLanguage") ?? lingual.selectLanguage
        lingual.language = findContentByTitle(langData: &langsData!, title: "language") ?? lingual.language
        lingual.vibrateFeedback = findContentByTitle(langData: &langsData!, title: "vibrateFeedback") ?? lingual.vibrateFeedback
        lingual.cannotUseVibrateFeature = findContentByTitle(langData: &langsData!, title: "cannotUseVibrateFeature") ?? lingual.cannotUseVibrateFeature
        lingual.notIPhoneCannotVibrate = findContentByTitle(langData: &langsData!, title: "notIPhoneCannotVibrate") ?? lingual.notIPhoneCannotVibrate
        
        lingual.newAccount = findContentByTitle(langData: &langsData!, title: "newAccount") ?? lingual.newAccount
        lingual.newPassword = findContentByTitle(langData: &langsData!, title: "newPassword") ?? lingual.newPassword
        lingual.confirmPassword = findContentByTitle(langData: &langsData!, title: "confirmPassword") ?? lingual.confirmPassword
        lingual.notice = findContentByTitle(langData: &langsData!, title: "notice") ?? lingual.notice
        lingual.confirm = findContentByTitle(langData: &langsData!, title: "confirm") ?? lingual.confirm
        lingual.accountCannotBeEmpty = findContentByTitle(langData: &langsData!, title: "accountCannotBeEmpty") ?? lingual.accountCannotBeEmpty
        lingual.accountOrPasswordIncorrect = findContentByTitle(langData: &langsData!, title: "accountOrPasswordIncorrect") ?? lingual.accountOrPasswordIncorrect
        lingual.accountAlreadyExists = findContentByTitle(langData: &langsData!, title: "accountAlreadyExists") ?? lingual.accountAlreadyExists
        lingual.registerSuccess = findContentByTitle(langData: &langsData!, title: "registerSuccess") ?? lingual.registerSuccess
        
        lingual.store = findContentByTitle(langData: &langsData!, title: "store") ?? lingual.store
        lingual.count = findContentByTitle(langData: &langsData!, title: "count") ?? lingual.count
        lingual.yourAnalysisGraph = findContentByTitle(langData: &langsData!, title: "yourAnalysisGraph") ?? lingual.yourAnalysisGraph
        lingual.day = findContentByTitle(langData: &langsData!, title: "day") ?? lingual.day
        lingual.week = findContentByTitle(langData: &langsData!, title: "week") ?? lingual.week
        lingual.month = findContentByTitle(langData: &langsData!, title: "month") ?? lingual.month
        lingual.youHaveTotalHunchbacksOf = findContentByTitle(langData: &langsData!, title: "youHaveTotalHunchbacksOf") ?? lingual.youHaveTotalHunchbacksOf
        lingual.lottery = findContentByTitle(langData: &langsData!, title: "lottery") ?? lingual.lottery
        lingual.realtimeHunchbackAnalysis = findContentByTitle(langData: &langsData!, title: "realtimeHunchbackAnalysis") ?? lingual.realtimeHunchbackAnalysis
        lingual.hunchbackStatus = findContentByTitle(langData: &langsData!, title: "hunchbackStatus") ?? lingual.hunchbackStatus
        
        lingual.darkUI = findContentByTitle(langData: &langsData!, title: "darkUI") ?? lingual.darkUI
        lingual.useDarkUIMode = findContentByTitle(langData: &langsData!, title: "useDarkUIMode") ?? lingual.useDarkUIMode
        
        lingual.dailyTarget = findContentByTitle(langData: &langsData!, title: "dailyTarget") ?? lingual.dailyTarget
        lingual.noHunchbackMoreThan = findContentByTitle(langData: &langsData!, title: "noHunchbackMoreThan") ?? lingual.noHunchbackMoreThan
        lingual.hunchbackTooManyTimes = findContentByTitle(langData: &langsData!, title: "hunchbackTooManyTimes") ?? lingual.hunchbackTooManyTimes
        lingual.hunchbackExceedDailyCount = findContentByTitle(langData: &langsData!, title: "hunchbackExceedDailyCount") ?? lingual.hunchbackExceedDailyCount
        
        lingual.youTotallyHave = findContentByTitle(langData: &langsData!, title: "youTotallyHave") ?? lingual.youTotallyHave
        lingual.timesHunchbacked = findContentByTitle(langData: &langsData!, title: "timesHunchbacked") ?? lingual.timesHunchbacked
        lingual.hunchbackTotalCount = findContentByTitle(langData: &langsData!, title: "hunchbackTotalCount") ?? lingual.hunchbackTotalCount
    }
}

