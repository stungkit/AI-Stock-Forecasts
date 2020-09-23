//
//  ResultView.swift
//  Stock Forecasts
//
//  Created by Alexis on 9/21/20.
//

import SwiftUI

struct ResultView: View {
    
    @State var selectedSegment: Segment?
    @Binding var hashScore: Int
    @Binding var arobaseScore: Int
    @Binding var newsScore: Int
    @Binding var name: String
    
    var stock: String
    
    // MARK: - Screen Body
    
    var body: some View {
        let body = GeometryReader { geometry in
            createBody(size: geometry.size)
                .edgesIgnoringSafeArea(.vertical)
                .colorScheme(.light)
                .navigationBarTitle("\(self.name)", displayMode: .inline)
        }
                        
        return body
    }
    
    private func createBody(size: CGSize) -> some View {
        let circleRadius = size.height / 2.0
        
        return ZStack {
            Color.background.edgesIgnoringSafeArea(.vertical)
            ScrollView {
                VStack(alignment: .center) {
                    StockChart(name: stock)
                    Divider()
                    createCircleControl(radius: circleRadius)
                    createDescription()
                    Text("@Score: \(arobaseScore)")
                    Text("#Score: \(hashScore)")
                    Text("NewsScore: \(newsScore)")
                    Spacer().frame(height: 200)
                }
            }.padding(.top, 88.0)
        }
    }
    
    // MARK: - Components
    
    private func createDescription() -> some View {
        return Group {
            Text(selectedSegment?.title ?? "")
                .font(.system(.headline))
                .fontWeight(.semibold)
                .fixedSize(horizontal: false, vertical: true)
            Group {
                Text(selectedSegment?.description ?? "")
                    .font(.system(.subheadline))
                    .fontWeight(.regular)
                    .foregroundColor(Color.gray.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.center)
            .lineLimit(3)
        }
    }
    
    private func createCircleControl(radius: CGFloat) -> some View {
        let totalBalance: Double = 200
        let segments: [Segment] = [
            Segment(
                color: Color.red.opacity(0.8),
                amount: 0,
                title: "Very Negative Outcome",
                description: "The company and the stock have very negative feedbacks - The value of the stock is likely to decrease in the near future"),
            Segment(
                color: Color.orange.opacity(0.8),
                amount: 40,
                title: "Slightly Negative Outcome",
                description: "The company and the stock have slightly negative feedbacks - The value of the stock may decrease slightly in the near future"),
            Segment(
                color: Color.yellow.opacity(0.8),
                amount: 80,
                title: "Stable Outcome",
                description: "The company and the stock have neutral feedbacks - The value of the stock is likely to stay stable in the near future"),
            Segment(
                color: Color.green.opacity(0.8),
                amount: 120,
                title: "Slightly Positive Outcome",
                description: "The company and the stock have slightly positive feedbacks - The value of the stock may increase slightly in the near future"),
            Segment(
                color: Color.blue.opacity(0.8),
                amount: 160,
                title: "Very Positive Outcome",
                description: "The company and the stock have very positive feedbacks - The value of the stock is likely to increase slightly in the near future")
        ]
        
        let circleControl = CircleControl(
            totalBalance: totalBalance,
            segments: segments,
            selectedSegment: $selectedSegment,
            hashScore: $hashScore,
            arobaseScore: $arobaseScore,
            newsScore: $newsScore
        )
        
        return circleControl
            .frame(width: radius, height: radius)
            .padding(16.0)
    }

}
