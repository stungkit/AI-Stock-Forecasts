import SwiftUI

struct TopBottomView: View {
    
    let network = Networking()
    
    var sector: String
    var type: ArrowType
    var fetchRequest: FetchRequest<CustomCompany>
    
    // Custom init for fetch request with a variable
    init(sector: String, type: ArrowType) {
        self.sector = sector
        self.type = type
        fetchRequest = FetchRequest<CustomCompany>(entity: CustomCompany.entity(), sortDescriptors: [], predicate: NSPredicate(format: "sector == %@", sector), animation: nil)
    }
    
    var allCompanies: [Company] {
        var results = CompaniesModel.getAllCompaniesFromSector(for: sector) ?? [Company(id: "ERROR", name: "ERROR", arobase: "ERROR", sector: "ERROR", custom: false)]
        for custom in fetchRequest.wrappedValue {
            results.append(Company(id: custom.wrappedId, name: custom.wrappedName, arobase: custom.wrappedArobase, sector: custom.wrappedSector, custom: true))
        }
        return results
    }
    
    @State private var ready: Bool = false
    @State private var progression: Double = 0.0
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.vertical)
            VStack(spacing: 5) {
                SectionTitle(
                    title: type == .up ? "Top 5 companies" : "Bottom 5 companies",
                    subTitle: type == .up ? "Best stock outcomes for the sector" : "Worst stock outcomes for the sector"
                )
                Spacer()
                Arrows(type: type)
                Spacer()
                Divider()
                createButtons().padding(.top, 5)
                ProgressView(value: progression, total: 1.0).padding(5)
            }
        }
        .colorScheme(.light)
        .navigationTitle("\(sector.capitalized)")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func createButtons() -> some View {
        // ButtonStyled is a custom component which can be found in the SharedComponents folder
        let predictButton = ButtonStyled(text: "forecast", color: Color.black)
        let buttonBeforePredict = ButtonStyled(text: "not ready", color: Color.gray.opacity(0.5))
        let buttonAfterPredict = ButtonStyled(text: "results", color: Color.blue)
        
        return HStack(spacing: 16.0) {
            
            Button(action: {
                for company in allCompanies {
                    network.fetchTweets1(company: company.arobase) { arobaseScore in
                        network.fetchTweets2(company: company.hash) { hashScore in
                            network.fetchData(company: String(company.arobase.dropFirst())) { newsScore in
                                progression += 1.0 / Double(allCompanies.count)
                                company.arobaseScore = arobaseScore
                                company.hashScore = hashScore
                                company.newsScore = newsScore
                                /*companyScoreArray.sort {
                                    $0.totalScore > $1.totalScore
                                }*/
                                ready = (progression > 0.999)
                            }
                        }
                    }
                }
            }) {
                predictButton
            }
            
            NavigationLink(destination: TopBottomResultsView(
                sector: sector,
                companyArray: allCompanies,
                type: type
            )) {
                ready ? buttonAfterPredict : buttonBeforePredict
            }
            .disabled(!ready)
            .simultaneousGesture(TapGesture().onEnded({
                self.ready = false
                self.progression = 0.0
            }))
        }
    }
    
}
