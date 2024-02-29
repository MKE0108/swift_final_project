import SwiftUI

struct UserView: View {
    
    @State var showLotterySpinning: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                
            }
            CircleDraggableButton(bgColor: .white, textColor: .black, imageName: "trophy.450x512", frontText: "抽獎") { 
                showLotterySpinning = true
            }
            LotteryWindowView(title: "抽獎", message: "抽獎嘍！！", buttonText: "按下抽獎", show: $showLotterySpinning)
        }
    }
}
