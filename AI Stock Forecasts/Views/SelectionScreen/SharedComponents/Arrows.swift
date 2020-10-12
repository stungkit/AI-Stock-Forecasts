import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        
        return path
    }
}

enum ArrowType {
    case up
    case down
}

struct Arrows: View {
    let blueType = Color.blue.opacity(0.8)
    let grayType = Color.gray.opacity(0.5)
    var type: ArrowType
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Triangle()
                    .rotation(Angle(degrees: 180))
                    .fill(type == .up ? blueType : grayType)
                    .frame(width: geo.size.height * 0.5, height: geo.size.height * 0.25, alignment: .center)
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(type == .up ? blueType : grayType)
                    .frame(width: geo.size.height * 0.25, height: geo.size.height * 0.25, alignment: .center)
                    .padding(.bottom, 5)
                Divider()
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(type == .down ? blueType : grayType)
                    .frame(width: geo.size.height * 0.25, height: geo.size.height * 0.25, alignment: .center)
                    .padding(.top, 5)
                Triangle()
                    //.stroke(Color.black, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .fill(type == .down ? blueType : grayType)
                    .frame(width: geo.size.height * 0.5, height: geo.size.height * 0.25, alignment: .center)
            }
        }
    }
}
