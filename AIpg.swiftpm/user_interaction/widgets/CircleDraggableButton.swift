import SwiftUI

struct CircleDraggableButton: View {
    @State private var dragAmount: CGPoint?
    
    @State private var width: CGFloat = 100
    @State private var height: CGFloat = 100
    @State private var startingPosOffset: CGFloat = 15
    
    private var bgColor: Color
    private var textColor: Color
    private var imageName: String
    private var frontText: String
    private var performAction: () -> Void
    
    init(bgColor: Color, textColor: Color, imageName: String, frontText: String, performAction: @escaping () -> Void) {
        self.bgColor = bgColor
        self.textColor = textColor
        self.imageName = imageName
        self.frontText = frontText
        self.performAction = performAction
    }
    
    var body: some View {
        GeometryReader { geo in // just to center initial position
            ZStack {
                Button(action: self.performAction) {
                    ZStack {
                        Circle()
                            .foregroundColor(bgColor)
                            .frame(width: width, height: height)
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width * 0.8, height: height * 0.8)
                        Text(frontText)
                            .foregroundColor(textColor)
                            .font(.system(size: 30, design: .serif))
                    }
                }
                // Use .none animation for glue effect
                .animation(.default, value: dragAmount)
                .position(self.dragAmount ?? CGPoint(x: geo.size.width - width / 2 - startingPosOffset, y: height / 2 + startingPosOffset))
                .highPriorityGesture(  // << to do no action on drag !!
                    DragGesture()
                        .onChanged { 
                            let movingBoundaryMin = CGPoint(x: width / 2, y: height / 2)
                            let movingBoundaryMax = CGPoint(x: geo.size.width - width / 2, y: geo.size.height - height / 2)
                            
                            var newLoc = $0.location
//                            if newLoc.x > geo.size.width - width / 2 {
//                                newLoc.x = geo.size.width - width / 2
//                            }
                            if newLoc.x > movingBoundaryMax.x {
                                newLoc.x = movingBoundaryMax.x
                            }
                            if newLoc.x < movingBoundaryMin.x {
                                newLoc.x = movingBoundaryMin.x
                            }
                            
                            if (newLoc.x > movingBoundaryMax.x)
                                || (newLoc.x < movingBoundaryMin.x)
                                || (newLoc.y < movingBoundaryMin.y)
                                || (newLoc.y > movingBoundaryMax.y) {
                                return
                            }
                            self.dragAmount = newLoc
                        })
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // full space
        }
    }
}
