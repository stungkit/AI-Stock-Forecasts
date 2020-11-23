import SwiftUI

struct HomeView: View {
    let sectorlist = [ "industrials", "healthcare", "technology", "telecom-media", "goods", "energy", "financials", "all"]
    let layout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.bottom)
                VStack {
                    HeaderView()
                    ScrollView {
                        LazyVGrid(columns: layout, spacing: 10) {
                            ForEach(sectorlist, id: \.self) { sector in
                                Tile(sector: sector)
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}
