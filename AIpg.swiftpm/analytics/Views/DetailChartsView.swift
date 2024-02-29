import SwiftUI

struct DetailChartsView: View {
    @ObservedObject var lingual: LingualModel
    let hbDatas: [HunchbackLineAnalysisUnit]
    
    enum TimeInterval: String, CaseIterable, Identifiable {
        case day = "日"
        case week = "週"
        case month = "月"
        
        var id: Self { return self }
    }
    
    @State private var selectedTimeinterval = TimeInterval.day
    
    var body: some View {
        VStack {
            Picker(selection: $selectedTimeinterval.animation()){
                ForEach(TimeInterval.allCases /*因為有使用 CaseIterable*/) { interval in
                    Text(interval.rawValue)
                }
            } label: {
                Text("Time Interval for chart")
            }
            .pickerStyle(.segmented)
            
            Text("\(lingual.youHaveTotalHunchbacksOf) \(hbDatas.count) \(lingual.day)")
            .padding(.vertical)
            
            Group {
                switch selectedTimeinterval {
                case .day:
                    DailyChartsView(hbDatas: self.hbDatas)
                case .week:
                    WeeklyChartsView(lingual: lingual, hbDatas: self.hbDatas)
                case .month:
                    MonthlyChartsView(hbDatas: self.hbDatas)
                }
            }
            .aspectRatio(0.8, contentMode: .fit)
            
            Spacer()
        }
        .padding()
    }
}

#Preview { 
    DetailChartsView(lingual: LingualModel(), hbDatas: HunchbackLineAnalysisUnit.dateExamples)
}
