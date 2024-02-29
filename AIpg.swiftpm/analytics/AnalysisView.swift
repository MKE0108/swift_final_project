import SwiftUI
import Charts

///
/// - Don't use Timer.scheduledTimer... in init() to create timer. Just use Timer.publish(...).autoconnect() It gets recreated everytime this view is inited.
/// ~~Also, the reason why setupAnalysisUnits() is called in init() instead of under .onAppear(), is because the data collection needs to be happened before this view appears. (It needs to work in the background so that it'll analyze data right away.)~~ UPDATE: This is an incorrect move. This will cause getting array values from UserDefaults not work.
/// - Getting array value from UserDefaults under init() doesn't seem to work.
/// - Why concatenating arrays under setupAnalysisUnits(): This is a complicated time issue. The UserDefaults arrays can only be retrieved under .onAppear(), not init(), or it won't work. But, the realtimeAnalysisUnits and byDateAnalysisUnits arrays rely on those UserDefaults arrays to get all the saved data. And also, the values must be started for appending right when the main menu in the app is started, even if this view hasn't appeared yet. This is why concatenation is set-up. It concatenates values saved before and the values appended during this app activity, when this view appears. So it will update and write the correct history data.
///
struct AnalysisView: View { 
    @ObservedObject var hunchbackDetect: HunchbackDetectModel
    @ObservedObject var lingual: LingualModel
    
    @State var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State var realtimeAnalysisUnits = [HunchbackLineAnalysisUnit]()
    @State var byDateAnalysisUnits = [HunchbackLineAnalysisUnit]()
    
    //    let realtimeTimerInterval = 20.0
    
//    init(hunchbackDetect: HunchbackDetectModel) {
//        _hunchbackDetect = StateObject(wrappedValue: hunchbackDetect)
//        
//        //        setupAnalysisUnits()
//    }
    
    var body: some View {
        VStack {
            NavigationStack {
                ScrollView {
//                    VStack (alignment: .leading){
//                        Text(lingual.realtimeHunchbackAnalysis)
//                            .fontWeight(.medium)
//                            .foregroundStyle(Color.black.opacity(0.7))
//                            .padding(.bottom)
//                        Chart(realtimeAnalysisUnits) {
//                            LineMark(
//                                x: .value("Current Time", $0.currentTime),
//                                y: .value("Count", $0.count)
//                            )
//                        }
//                    }
//                    .aspectRatio(1, contentMode: .fit)
//                    .frame(width: UIScreen.main.bounds.width*8/12, height: 400)
//                    .padding()
                    
                    NavigationLink { 
                        DetailChartsView(lingual: lingual, hbDatas: byDateAnalysisUnits)
                    } label: { 
                        SimpleChartsOverview(lingual: lingual, datas: byDateAnalysisUnits)
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width*8/12, height: 400)
                    .padding()
                    
                    Spacer(minLength: 20)
                }
                .navigationTitle(lingual.hunchbackStatus)
                
            }
        }
        .padding(15)
        .onAppear(perform: {
            setupAnalysisUnits()
        })
        .onReceive(timer) { _ in
            onReceiveTimer()
        }
        .onDisappear(perform: {
            cleanupAnalysisUnits()
        })
        //        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification), perform: { _ in
        //            cleanupAnalysisUnits()
        //        })
    }
    
    func saveAnalysisUnits() {
        let (realtimeCurrentTimes, realtimeCounts) = hunchbackLineAnalysisUnitToRaw(hunchbackLineAnalysisUnits: &realtimeAnalysisUnits)
        
        print("Saving realtime units, count: \(realtimeCurrentTimes.count)")
        
        // RealtimeAnalysisCurrentTimes
        UserDefaults.standard.setValue(realtimeCurrentTimes, forKey: "RACT")
        // RealtimeAnalysisCounts
        UserDefaults.standard.setValue(realtimeCounts, forKey: "RAC")
        
        let (byDateCurrentTimes, byDateCounts) = hunchbackLineAnalysisUnitToRaw(hunchbackLineAnalysisUnits: &byDateAnalysisUnits)
        // ByDateAnalysisCurrentTimes
        UserDefaults.standard.set(byDateCurrentTimes, forKey: "BDACT")
        // ByDateAnalysisCounts
        UserDefaults.standard.set(byDateCounts, forKey: "BDAC")
        UserDefaults.standard.synchronize()
    }
    
    func setupAnalysisUnits() {
        var realtimeCurrentTimes: [String]? = UserDefaults.standard.array(forKey: "RACT") as? [String]
        var realtimeCounts: [Int]? = UserDefaults.standard.array(forKey: "RAC") as? [Int]
        if realtimeCurrentTimes != nil && realtimeCounts != nil {
            let __realtimeAnalysisUnits = lineAnalysisRawsToHunchbackUnits(currentTimes: &realtimeCurrentTimes!, counts: &realtimeCounts!)
            print("Realtime analysis read succeeded. Count: \(realtimeAnalysisUnits.count)")
            realtimeAnalysisUnits = __realtimeAnalysisUnits + realtimeAnalysisUnits
        }
        
//        var byDateCurrentTimes: [String]? = UserDefaults.standard.array(forKey: "BDACT") as? [String]
//        var byDateCounts: [Int]? = UserDefaults.standard.array(forKey: "BDAC") as? [Int]
//        if byDateCurrentTimes != nil && byDateCounts != nil {
//            let __byDateAnalysisUnits = lineAnalysisRawsToHunchbackUnits(currentTimes: &byDateCurrentTimes!, counts: &byDateCounts!)
//            byDateAnalysisUnits = __byDateAnalysisUnits + byDateAnalysisUnits
//        }
    }
    
    func cleanupAnalysisUnits() {
        print("Current realtime units: \(realtimeAnalysisUnits.count)")
        print("Current by date units: \(byDateAnalysisUnits.count)")
        if realtimeAnalysisUnits.count > 0 {
            print("Cleaning up units...")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = InDateFormat
            
            for unit in realtimeAnalysisUnits {
                dateFormatter.dateFormat = RealtimeFormat
                guard let dateInRealtime: Date = dateFormatter.date(from: unit.currentTime) else {
                    print("Conversion failed...")
                    realtimeAnalysisUnits.removeAll()
                    return
                }
                
                dateFormatter.dateFormat = InDateFormat
                let dateStrInDate: String = dateFormatter.string(from: dateInRealtime)
                
                var hasAdded: Bool = false
                for (index, byDateAnalysisUnit) in byDateAnalysisUnits.enumerated() {
                    if byDateAnalysisUnit.currentTime != dateStrInDate {continue}
                    
                    byDateAnalysisUnits[index].count += unit.count
                    hasAdded = true
                    break
                }
                
                if !hasAdded {byDateAnalysisUnits.append(HunchbackLineAnalysisUnit(currentTime: dateStrInDate, count: unit.count))}
            }
            
            realtimeAnalysisUnits.removeAll()
        }
        if byDateAnalysisUnits.count > 100 {
            byDateAnalysisUnits.removeAll()
        }
        
        saveAnalysisUnits()
    }
    
    func onReceiveTimer() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = RealtimeFormat
        
        let currentTimeInMinsAndSecs = dateFormatter.string(from: Date()) 
        
        
        realtimeAnalysisUnits.append(HunchbackLineAnalysisUnit(currentTime: currentTimeInMinsAndSecs, count: hunchbackDetect.realtimeTotalCount))
        
        hunchbackDetect.realtimeTotalCount = 0
        
        cleanupAnalysisUnits()
    }
}

#Preview {
    AnalysisView(hunchbackDetect: HunchbackDetectModel(), lingual: LingualModel())
}
