import SwiftUI
import Charts

struct DailyChartsView: View {
    let hbDatas: [HunchbackLineAnalysisUnit]
    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
            Chart(hbDatas) { hbData in
                //            let dateFmter = DateFormatter()
                //            dateFmter.dateFormat = "MM/dd"
                BarMark(x: .value("Day", /*dateFmter.date(from: */hbData.currentTime/*), unit: .day*/),
                        y: .value("Data", hbData.count))
                .foregroundStyle(Color.yellow.gradient)
            }
//            if #available(macCatalyst 17.0, *) {
//                chartScrollableAxes(.horizontal)
//            } else {
//                // Fallback on earlier versions
//            }
//        }
    }
}

#Preview {
    DailyChartsView(hbDatas: HunchbackLineAnalysisUnit.dateExamples)
        .aspectRatio(1, contentMode: .fit)
        .padding()
}
