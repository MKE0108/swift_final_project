import SwiftUI

struct StoreView: View {
    @ObservedObject var lingual: LingualModel
    @State var showLotterySpinning: Bool = false
    
    var body: some View {
        ZStack {
            WebView(url: URL(string: "https://lambent-pothos-a26bae.netlify.app/?fbclid=IwAR3qaJ0635I_8E__sX8FIHIjfwF61bWK-NdYqHvHAlKxZJXj2khetGUvWGY")!)
            CircleDraggableButton(bgColor: .white, textColor: .black, imageName: "trophy.450x512", frontText: lingual.lottery) { 
                showLotterySpinning = true
            }
            LotteryWindowView(title: lingual.lottery, message: "\(lingual.lottery)！！", buttonText: lingual.confirm, show: $showLotterySpinning)
        }
    }
}
