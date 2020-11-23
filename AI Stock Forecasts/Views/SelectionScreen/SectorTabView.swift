import SwiftUI

struct SectorTabView: View {
    var sector: String
    var body: some View {
        TabView {
            SelectionView(sector: sector)
                .tabItem {
                    Image(systemName: "target")
                    Text("Single")
                }
            TopBottomView(sector: sector, type: .up)
                .tabItem {
                    Image(systemName: "chevron.up")
                    Text("Top 5")
                }
            TopBottomView(sector: sector, type: .down)
                .tabItem {
                    Image(systemName: "chevron.down")
                    Text("Bottom 5")
                }
        }
        .colorScheme(.light)
        .navigationTitle("\(sector.capitalized)")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

