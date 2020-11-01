import SwiftUI

struct HeaderView: View {
    var body: some View {
        ZStack {
            Color(UIColor(named: "HeaderViewColor") ?? UIColor.white)
                .edgesIgnoringSafeArea(.top)
                .frame(width: nil, height: 80, alignment: .center)
            
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 10) {
                Image("titleImage")
                    .resizable()
                    .frame(width: 64, height: 64)
                Text("AI Stock Forecasts")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
        }
    }
}

