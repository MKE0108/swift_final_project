import SwiftUI

struct SettingsView : View {
    
    @ObservedObject var userSettings: UserSettingsModel
    @ObservedObject var lingual: LingualModel
    
    @State var showNotIphoneAlert = false
//    @State var languageSelected = 0
    
    let languageOptions = ["中文", "English", "Lingua Latina", "日本語", "Tiếng Việt", "한국어"]
    
    var body: some View {
        VStack {
            Divider()
            Text(lingual.tabSettings)
                .font(.title)
            Divider()
            Form(content: {
                Section(header: Text(lingual.vibrateFeedback), content: {
                    Toggle(isOn: $userSettings.useVibrationPublished, label: {
                        Text(lingual.useVibrationWhenDetectHunchback)
                    })
                    .onChange(of: userSettings.useVibrationPublished) { value in
                        if !value {return}
                        if !UIDevice.isIPhone {
                            userSettings.useVibrationPublished = false
                            showNotIphoneAlert = true
                        }
                    }
                })
                Section(header: Text(lingual.darkUI), content: {
                    Toggle(isOn: $userSettings.useDarkMode, label: {
                        Text(lingual.useDarkUIMode)
                    })
                })
                Section(header: Text(lingual.language), content: {
                    Picker(selection: $userSettings.appUserLangPublished, label: Text("\(lingual.selectLanguage) (\(AppUserLanguage(rawValue: userSettings.appUserLangPublished)!.description))")) {
                        ForEach(0..<languageOptions.count, id: \.self, content: {
                            Text(self.languageOptions[$0])
                        })
                    }
                })
                Section(header: Text(lingual.dailyTarget), content: {
                    Stepper("\(lingual.noHunchbackMoreThan) \(userSettings.limitValuePublished) \(lingual.count)", onIncrement: {userSettings.limitValuePublished += 1}, onDecrement: {userSettings.limitValuePublished -= 1})
                })
            })
            Spacer()
        }
        .padding(EdgeInsets(top: 20, leading: 15, bottom: 20, trailing: 15))
        .alert(isPresented: $showNotIphoneAlert) {
            Alert(
                title: Text(lingual.cannotUseVibrateFeature),
                message: Text(lingual.notIPhoneCannotVibrate)
            )
        }
    }
}
