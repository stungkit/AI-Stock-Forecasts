import SwiftUI

struct CircleControl: View {
    
    let totalBalance: Double
    let segments: [Segment]
    
    @Binding var selectedSegment: Segment?
    
    var company: Company
    
    var shiftedScore: Double {
        return company.totalScore + 100 // from 0 to 200
    }
    
    private let lineWidth: CGFloat = 44.0
    
    // MARK: - Screen body
    
    var body: some View {
        let body = GeometryReader { geometry in
            createBody(size: geometry.size)
        }
            
        return body.onAppear {
            selectedSegment = currentSegment()
        }
    }
    
    private func createBody(size: CGSize) -> some View {
        let controlRadius: CGFloat = size.width / 2.0
        
        return ZStack {
            createOuterCircle(radius: controlRadius)
            createInnerCircle(radius: controlRadius)
            createProgressArc(radius: controlRadius)
            createTopArc(radius: controlRadius)
            createPoints(radius: controlRadius)
            createControlPoint(radius: controlRadius)
            createCurrentValueText(radius: controlRadius)
        }
    }
    
    // MARK: - Components
    
    private func createOuterCircle(radius: CGFloat) -> some View {
        let diametr: CGFloat = radius * 2.0 - 4.0

        return Group {
            Circle().fill(Color.white)
            Circle().fill(Color.controlFill)
                // incorrect error message with xcode12 - should work fine
                .frame(width: diametr, height: diametr)
        }
    }
    
    private func createInnerCircle(radius: CGFloat) -> some View {
        let diametr = radius * 2.0 - lineWidth * 2.0
        let innerDiametr = diametr - 4.0
        
        return Group {
            Circle()
                .fill(Color.white)
                // incorrect error message with xcode12 - should work fine
                .frame(width: diametr, height: diametr)
            
            Circle()
                .fill(Color.background)
                // incorrect error message with xcode12 - should work fine
                .frame(width: innerDiametr, height: innerDiametr)
        }
    }
    
    private func createProgressArc(radius: CGFloat) -> some View {
        let center = CGPoint(x: radius, y: radius)
        let angle = Double(shiftedScore / totalBalance * 2 * .pi - .pi / 2.0)
        let color = currentSegment()?.color ?? Color.white
        let gradient = LinearGradient(
            gradient: Gradient(colors: [color.opacity(0.6), color]),
            startPoint: .leading,
            endPoint: .trailing)
        
        return Path { path in
            path.addArc(
                center: center,
                radius: radius - lineWidth / 2.0 - 1.0,
                startAngle: .radians(-.pi / 2.0),
                endAngle: .radians(angle),
                clockwise: false)
            path = path.strokedPath(.init(lineWidth: lineWidth - 2.0))
        }.fill(gradient)
    }
    
    private func createTopArc(radius: CGFloat) -> some View {
        let center = CGPoint(x: radius, y: lineWidth / 2.0 + 1.0)
        let rect = CGRect(
            x: radius - lineWidth / 2.0,
            y: 2.0,
            width: lineWidth,
            height: lineWidth - 2.0)
        
        return Group {
            Path { path in
                path.addEllipse(in: rect)
            }.foregroundColor(Color.controlFill)
            
            Path { path in
                path.addArc(
                    center: center,
                    radius: lineWidth / 2.0,
                    startAngle: .radians(-.pi / 2.0),
                    endAngle: .radians(.pi / 2.0),
                    clockwise: false)
                path = path.strokedPath(.init(lineWidth: 2.0))
            }.foregroundColor(.white)
        }
    }
    
    private func createPoints(radius: CGFloat) -> some View {
        return Group {
            ForEach(0..<segments.count) { index in
                self.createPoint(valuePosition: self.segments[index].amount, radius: radius)
            }
            createPoint(valuePosition: totalBalance, radius: radius)
        }
    }
    
    private func createPoint(valuePosition: Double, radius: CGFloat) -> some View {
        let pointWidth: CGFloat = 16.0
        let angle = CGFloat(valuePosition / totalBalance * 2 * .pi - .pi / 2.0)
        let center = CGPoint(x: radius, y: radius)
        let radius = radius - lineWidth / 2.0 - 1.0
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)
        let pointCenter = CGPoint(x: x, y: y)
        let rect = CGRect(
            x: pointCenter.x - pointWidth / 2.0,
            y: pointCenter.y - pointWidth / 2.0,
            width: pointWidth,
            height: pointWidth)
      
        return Path { path in
                path.addEllipse(in: rect)
            }.foregroundColor(.point)
    }
    
    private func createCurrentValueText(radius: CGFloat) -> some View {
        let diametr = radius * 2.0 - lineWidth * 2.0 - 16.0
        return VStack {
            Text("Score:")
            Text("\(String(format: "%.0f", company.totalScore))")
        }.font(Font.system(size: 40.0, weight: .bold, design: .rounded))
        // incorrect error message with xcode12 - should work fine
        .frame(width: diametr, height: 75.0, alignment: .center)
        .minimumScaleFactor(0.5)
    }
    
    private func createControlPoint(radius: CGFloat) -> some View {
        let angle = CGFloat(shiftedScore / totalBalance * 2 * .pi - .pi / 2.0)
        let controlRadius = radius - lineWidth / 2.0 - 1.0
        let center = CGPoint(x: radius, y: radius)
        let x = center.x + controlRadius * cos(angle)
        let y = center.y + controlRadius * sin(angle)
        let pointCenter = CGPoint(x: x, y: y)
        
        let borderRect = CGRect(
            x: pointCenter.x - lineWidth / 2.0,
            y: pointCenter.y - lineWidth / 2.0,
            width: lineWidth + 2.0,
            height: lineWidth + 2.0)
        
        let rect = CGRect(
            x: pointCenter.x - lineWidth / 2.0 + 4.0,
            y: pointCenter.y - lineWidth / 2.0 + 4.0,
            width: lineWidth - 6.0,
            height: lineWidth - 6.0)
        
        let color = currentSegment()?.color ?? .white
        
        return Group {
            Path { path in
                path.addEllipse(in: borderRect)
            }.foregroundColor(.white)
            
            Path { path in
                path.addEllipse(in: rect)
            }.foregroundColor(color)
        }
    }

    
    // MARK: -
    
    private func currentSegment() -> Segment? {
        return segments.last { $0.amount <= shiftedScore } ?? segments.first
    }
    
    private func nearestSegmentPoint(value: Double) -> Segment? {
        let magnetCoef = min(totalBalance * 0.025, 50.0)
        return segments.first { $0.amount < value + magnetCoef && $0.amount > value - magnetCoef }
    }
}

struct Segment: Equatable {
    
    let color: Color
    let amount: Double
    let title: String
    let description: String
}
