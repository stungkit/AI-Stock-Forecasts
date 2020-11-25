import SwiftUI

struct SectorTabView: View {
    @Environment(\.managedObjectContext) private var moc
    //@FetchRequest(entity: CustomCompany.entity(), sortDescriptors: []) var customCompanies: FetchedResults<CustomCompany>
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
            AddView(sector: sector)
                .tabItem {
                    Image(systemName: "plus")
                    Text("Add Company")
                }
        }
        .colorScheme(.light)
        .navigationTitle("\(sector.capitalized)")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

