import SwiftUI

///
/// Remember to add @Published, so that changes to the fields will update
/// back to UIs that use them.
///
class LingualModel : ObservableObject {
    @Published var appTitle: String = ""
    
    @Published var tabMonitor: String = ""
    @Published var tabData: String = ""
    @Published var tabUser: String = ""
    @Published var tabSettings: String = ""
    @Published var login: String = ""
    @Published var account: String = ""
    @Published var password: String = ""
    @Published var signUp: String = ""
    @Published var register: String = ""
    
    @Published var detectionMode: String = ""
    @Published var correctionMode: String = ""
    @Published var noTarget: String = ""
    @Published var correction: String = ""
    @Published var afterSecs: String = ""
    @Published var leftover: String = ""
    @Published var second: String = ""
    @Published var sideways: String = ""
    @Published var hunchback: String = ""
    @Published var idle: String = ""
    
    @Published var useVibrationWhenDetectHunchback: String = ""
    @Published var selectLanguage: String = ""
    @Published var language: String = ""
    @Published var vibrateFeedback: String = ""
    @Published var cannotUseVibrateFeature: String = ""
    @Published var notIPhoneCannotVibrate: String = ""
    
    @Published var newAccount: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var notice: String = ""
    @Published var confirm: String = ""
    @Published var accountCannotBeEmpty: String = ""
    @Published var accountOrPasswordIncorrect: String = ""
    @Published var accountAlreadyExists: String = ""
    @Published var registerSuccess: String = ""
    
    @Published var store: String = ""
    @Published var count: String = ""
    @Published var yourAnalysisGraph: String = ""
    @Published var day: String = ""
    @Published var week: String = ""
    @Published var month: String = ""
    @Published var youHaveTotalHunchbacksOf: String = ""
    @Published var lottery: String = ""
    @Published var realtimeHunchbackAnalysis: String = ""
    @Published var hunchbackStatus: String = ""
    
    @Published var darkUI: String = ""
    @Published var useDarkUIMode: String = ""
    
    @Published var dailyTarget = ""
    @Published var noHunchbackMoreThan = ""
    @Published var hunchbackTooManyTimes = ""
    @Published var hunchbackExceedDailyCount = ""
    
    @Published var youTotallyHave = ""
    @Published var timesHunchbacked = ""
    @Published var hunchbackTotalCount = ""
}
