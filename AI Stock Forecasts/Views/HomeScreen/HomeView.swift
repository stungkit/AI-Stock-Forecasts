import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var moc
    //@FetchRequest(entity: CustomCompany.entity(), sortDescriptors: []) var customCompanies: FetchedResults<CustomCompany>
    let layout = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationView {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.bottom)
                VStack {
                    HeaderView()
                    ScrollView {
                        NavigationLink(destination: CustomCompanyList()) {
                            Text("Manage custom companies")
                        }
                        Divider()
                        LazyVGrid(columns: layout, spacing: 10) {
                            ForEach(Sector.allCases, id: \.self) { sector in
                                Tile(sector: sector.rawValue)
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}
