import SwiftUI
import Charts

struct MonthlyChartsView: View {
    let hbDatas: [HunchbackLineAnalysisUnit]
    var body: some View {
        Chart(hbDatas) { hbData in
            //            let dateFmter = DateFormatter()
            //            dateFmter.dateFormat = "MM/dd"
            BarMark(x: .value("Day", /*dateFmter.date(from: */hbData.currentTime/*), unit: .weekOfYear*/),
                    y: .value("Data", hbData.count))
            .foregroundStyle(Color.yellow.gradient)
        }
        //TODO 等日期用 date
//        .chartXAxis { 
//            AxisMarks { AxisValue in 
//                // 加 x 軸月份標籤，並於長條圖置中
//                AxisValueLabel(format: .dateTime.month(.abbreviated), centered: true)
//            }
//        }
    }
}

#Preview {
    MonthlyChartsView(hbDatas: HunchbackLineAnalysisUnit.dateExamples)
        .aspectRatio(1, contentMode: .fit)
        .padding()
}
