
import SwiftUI

struct MainView: View {
    
    @ObservedObject var userSettings: UserSettingsModel
    @ObservedObject var lingual: LingualModel
    @StateObject var hunchbackDetect = HunchbackDetectModel()
    
//    @StateObject var userSettings = UserSettingsModel()
    @State private var showPopupNoticeWindow: Bool = true
    
    var body: some View {
        ZStack {
            VStack {
                TabView {
                    Group {
                        BodyDetectionView(lingual: lingual, hunchbackDetection: hunchbackDetect, userSettings: userSettings)
                            .tabItem {
                                VStack{
                                    Image(systemName: "sensor.fill")
//                                    Text(lingual.tabMonitor)
                                }
                            }
                        AnalysisView(hunchbackDetect: hunchbackDetect, lingual: lingual)
                            .tabItem { 
                                VStack{
                                    Image(systemName: "doc.fill")
//                                    Text(lingual.tabData)
                                }
                            }
                        StoreView(lingual: lingual)
                            .tabItem { 
                                VStack{
                                    Image(systemName: "tray.fill")
//                                    Text(lingual.store)
                                }
                            }
                        SettingsView(userSettings: userSettings, lingual: lingual)
                            .tabItem { 
                                VStack{
                                    Image(systemName: "gearshape.fill")
//                                    Text(lingual.tabSettings)
                                }
                            }
                    }
                    .toolbarBackground(Color.black, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarColorScheme(.dark, for: .tabBar)
                }
            }
            
            PopupNoticeWindowView(title: "最新消息", message: appVerMetadatasAsStr(appVerMetadatas: loadJsonFile("app_ver_metadata.json")), buttonText: "瞭解了", show: $showPopupNoticeWindow)
            //                LoadingScreenView()
        }
    }
}


