import SwiftUI

struct Tile: View {
    let sector: String
    var body: some View {
        NavigationLink(destination: SectorTabView(sector: sector)) {
            VStack {
                Image(sector)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 128, height: 128)
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 2))
                Divider()
                Text(sector.uppercased())
            }
        }
    }
}
