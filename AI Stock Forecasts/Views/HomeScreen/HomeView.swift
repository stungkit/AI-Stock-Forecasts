import SwiftUI

struct HomeView: View {
    let iconlist = [ "industrials", "healthcare", "technology", "telecom-media", "goods", "energy", "financials", "all"]
    let layout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.bottom)
                VStack {
                    TitleView()
                    ScrollView {
                        LazyVGrid(columns: layout, spacing: 10) {
                            ForEach(iconlist, id: \.self) { item in
                                Tile(name: item)
                            }
                        }
                    }
                }
            }
            .colorScheme(.light)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
}
