import SwiftUI

struct LoadingScreenView: View {
    @ObservedObject var lingual: LingualModel
    
    @State private var opacity = 1.0
    @State private var isVisible = true
    @State private var isLoading = false
    
    private let bgColor: Color = Color(red: 230, green: 62, blue: 37)
    private let fadeOutDelay: Double = 3.0
    private let fadeOutLength: Double = 1.0
    
    var body: some View {
        if isVisible {
            ZStack {
                Rectangle()
                    .foregroundColor(bgColor)
                    .frame(width: .infinity, height: .infinity)
                VStack {
                    Text(lingual.appTitle)
                        .font(.system(size: 48))
                        .bold()
                    Image("hunchback_logo_transp")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                }
                
            }
            .opacity(opacity)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + fadeOutDelay) {
                    withAnimation(.easeInOut(duration: fadeOutLength)) { 
                        opacity = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + fadeOutDelay + fadeOutLength) {
                        isVisible = false
                    }
                }
            }
        }
    }
}
