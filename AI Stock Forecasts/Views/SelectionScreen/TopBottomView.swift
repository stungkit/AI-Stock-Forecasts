import SwiftUI

struct TopBottomView: View {
    
    let network = Networking()
    
    var sector: String
    var type: ArrowType
    
    var allCompanies: [Company] {
        CompaniesModel.getAllCompaniesFromSector(for: sector) ?? [Company(name: "ERROR", hash: "ERROR", arobase: "ERROR")]
    }
    
    @State private var companyScoreArray: [CompanyScore] = [CompanyScore]()
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
        .navigationBarTitle("\(sector.capitalized)", displayMode: .inline)
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
                            network.fetchData(company: company.symbol) { newsScore in
                                progression += 1.0 / Double(allCompanies.count)
                                companyScoreArray.append(CompanyScore(
                                    id: UUID(),
                                    name: company.name,
                                    symbol: company.symbol,
                                    hashScore: hashScore,
                                    arobaseScore: arobaseScore,
                                    newsScore: newsScore
                                ))
                                companyScoreArray.sort {
                                    $0.totalScore > $1.totalScore
                                }
                                ready = (allCompanies.count == companyScoreArray.count)
                            }
                        }
                    }
                }
            }) {
                predictButton
            }
            
            NavigationLink(destination: TopBottomResultsView(
                sector: sector,
                companyScoreArray: companyScoreArray,
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
