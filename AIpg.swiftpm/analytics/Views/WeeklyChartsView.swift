import SwiftUI
import Charts

struct WeeklyChartsView: View {
    @ObservedObject var lingual: LingualModel
    
    let hbDatas: [HunchbackLineAnalysisUnit]
    
    @State var thisBarDate: String? = nil
    @State var thisBarValue = 0
    @State var isLeading = true
    
    var body: some View {
        Chart() {
            ForEach(hbDatas){ hbData in
                //            let dateFmter = DateFormatter()
                //            dateFmter.dateFormat = "MM/dd"
                BarMark(x: .value("Day", /*dateFmter.date(from: */hbData.currentTime/*), unit: .weekOfYear*/),
                        y: .value("Data", hbData.count)
                )
                .foregroundStyle(Color.yellow.gradient)
            }
            if let thisBarDate {
                RuleMark(x: .value("Focus", thisBarDate))
                    .foregroundStyle(.gray.opacity(0.3))
                    .annotation(position: .top, 
                                spacing: -60) {
                        VStack {
                            Text("\(lingual.hunchback) \n \(thisBarValue) \(lingual.count)")
                                .padding(.horizontal)
                        }
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white)
                                .shadow(color: .gray, radius: 2)
                        )
                    }
            }
        }
        .chartOverlay { chartProxy in
            GeometryReader { geoProxy in
//                覆蓋 rectangle 至整個圖表
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(DragGesture()
                        .onChanged{ value in
//                            圖表實際位置（扣除與圖表無關的東西後）
//                            TODO plotAreaFrame will deprecate in ios 17.0
                            let plotArea = geoProxy[chartProxy.plotAreaFrame]
//                            手指目前座標
                            let xPosition = value.location.x - plotArea.origin.x
                            
                            for hbData in hbDatas {
//                                抓每條的 x 範圍
                                if let range = chartProxy.positionRange(forX: hbData.currentTime) {
                                    if range.contains(xPosition) {
                                        thisBarDate = hbData.currentTime    
                                        thisBarValue = hbData.count
                                        
                                        break
                                    }
                                }
                            }
                        }
                        .onEnded{ _ in
                            thisBarDate = nil
                        }
                    )
            }
        }
    }
}

#Preview {
    WeeklyChartsView(lingual: LingualModel(), hbDatas: HunchbackLineAnalysisUnit.dateExamples)
        .aspectRatio(contentMode: .fit)
        .padding()
}
