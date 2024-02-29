import SwiftUI

struct SimpleChartsOverview: View {
    @ObservedObject var lingual: LingualModel
    
    /*@ObservedObject 待思考是否要讓資料型別為可訂閱的物件*/var datas: [HunchbackLineAnalysisUnit]    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(lingual.yourAnalysisGraph) //TODO 加上數據分析語句
                    .fontWeight(.medium)
                    .foregroundStyle(Color.black.opacity(0.7))
                    .padding(.bottom)
            }
            
            WeeklyChartsView(lingual: lingual, hbDatas: datas)
                .frame(height: 100)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
        }
        
    }
}

#Preview {
    SimpleChartsOverview(lingual: LingualModel(), datas: HunchbackLineAnalysisUnit.dateExamples)
        .padding()
}
