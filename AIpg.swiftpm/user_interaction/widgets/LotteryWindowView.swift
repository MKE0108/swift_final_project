import SwiftUI

struct LotteryWindowView: View {
    var title: String
    var message: String
    var buttonText: String
    @Binding var show: Bool
    var body: some View {
        GeometryReader { geo in
            ZStack {
                if show {
                    // PopUp background color
                    Color.black.opacity(show ? 0.8 : 0)
                        .edgesIgnoringSafeArea(.all)
                    
                    // PopUp Window
                    VStack(alignment: .center, spacing: 0) {
                        Text(title)
                            .frame(maxWidth: .infinity)
                            .frame(height: 45, alignment: .center)
                            .font(Font.system(size: 23, weight: .semibold))
                            .foregroundColor(Color.white)
                            .background(Color(red: 0.3, green: 0.3, blue: 0.6))
//                        Text(message)
//                            .multilineTextAlignment(.leading)
//                            .font(Font.system(size: 16, weight: .semibold))
//                            .padding(EdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25))
//                            .foregroundColor(Color.white)
                        FrameByFrameView(currentFrameName: "JACKPOT-", endFrame: 240, frameInterval: 0.03, shouldRepeat: true)
                        
                        Button(action: {
                            // Dismiss the PopUp
                            withAnimation(.linear(duration: 0.3)) {
                                show = false
                            }
                        }, label: {
                            Text(buttonText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54, alignment: .center)
                                .foregroundColor(Color.white)
                                .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .font(Font.system(size: 23, weight: .semibold))
                        }).buttonStyle(PlainButtonStyle())
                    }
                    .frame(maxWidth: geo.size.width * 0.8)
                    .border(Color.white, width: 2)
                    .background(Color(red: 0.3, green: 0.3, blue: 0.3))
                }
            }
        }
    }
}
