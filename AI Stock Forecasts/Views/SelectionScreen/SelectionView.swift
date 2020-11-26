import SwiftUI

struct SelectionView: View {
    
    let network = Networking()
    
    // MARK: - Variables
    
    var sector: String
    var fetchRequest: FetchRequest<CustomCompany>
    
    // Custom init for fetch request with a variable
    init(sector: String) {
        self.sector = sector
        fetchRequest = FetchRequest<CustomCompany>(entity: CustomCompany.entity(), sortDescriptors: [], predicate: NSPredicate(format: "sector == %@", sector), animation: nil)
    }
    
    var allCompanies: [Company] {
        var results = CompaniesModel.getAllCompaniesFromSector(for: sector) ?? [Company(name: "ERROR", hash: "ERROR", arobase: "ERROR")]
        for custom in fetchRequest.wrappedValue {
            results.append(Company(name: custom.wrappedName, hash: custom.wrappedHash, arobase: custom.wrappedArobase))
        }
        return results
    }
    
    // MARK: - States
    
    @State private var selectedCompanyIndex: Int = 0
    @State private var ready: Bool = false
    @State private var progression: Double = 0.0
    @State private var companyScore = CompanyScore(id: UUID(), name: "ERROR", symbol: "ERROR", hashScore: 0, arobaseScore: 0, newsScore: 0)
    
    // MARK: - Screen body
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.vertical)
            VStack(alignment: .center, spacing: 5) {
                SectionTitle(title: "Company Selection", subTitle: "Select a company in the list below: ")
                createPicker()
                Spacer()
                createLogoImage(hash: allCompanies[selectedCompanyIndex].hash)
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
    
    // MARK: - Components
    
    private func createPicker() -> some View {
        return VStack {
            Picker(selection: $selectedCompanyIndex.animation(.easeInOut), label: Text("")) {
                ForEach(0 ..< allCompanies.count) {
                    Text(allCompanies[$0].name)
                }
            }
            .labelsHidden()
            HStack {
                Text("Your have selected: ")
                Text("\(allCompanies[selectedCompanyIndex].name)")
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
            }
        }
    }
    
    private func createLogoImage(hash: String) -> some View {
        return Image(hash)
            .resizable()
            .scaledToFit()
            .padding(5)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            .shadow(color: .gray, radius: 2)
            .padding(5)
    }
    
    private func createButtons() -> some View {
        // ButtonStyled is a custom component which can be found in the Components folder
        let predictButton = ButtonStyled(text: "forecast", color: Color.black)
        let buttonBeforePredict = ButtonStyled(text: "not ready", color: Color.gray.opacity(0.5))
        let buttonAfterPredict = ButtonStyled(text: "results", color: Color.blue)
        
        return HStack(spacing: 16.0) {
            
            Button(action: {
                let selectedCompany = allCompanies[selectedCompanyIndex]
                
                network.fetchTweets1(company: selectedCompany.arobase) { arobaseScore in
                    progression = 0.3
                    network.fetchTweets2(company: selectedCompany.hash) { hashScore in
                        progression = 0.6
                        network.fetchData(company: String(selectedCompany.arobase.dropFirst())) { newsScore in
                            companyScore = CompanyScore(
                                id: UUID(),
                                name: selectedCompany.name,
                                symbol: selectedCompany.symbol,
                                hashScore: hashScore,
                                arobaseScore: arobaseScore,
                                newsScore: newsScore
                            )
                            progression = 1.0
                            ready = true
                        }
                    }
                }
            }) {
                predictButton
            }
            
            NavigationLink(destination: ResultView(
                hashScore: companyScore.hashScore,
                arobaseScore: companyScore.arobaseScore,
                newsScore: companyScore.newsScore,
                name: companyScore.name,
                totalScore: companyScore.totalScore,
                stockSymbol: companyScore.symbol
                
            )) {
                ready ? buttonAfterPredict : buttonBeforePredict
            }
            .disabled(!ready)
            .simultaneousGesture(TapGesture().onEnded({
                ready = false
                progression = 0.0
            }))
        }
    }
    
}
