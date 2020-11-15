import SwiftUI

struct SelectionView: View {
    
    let network = Networking()
    
    // MARK: - Variables
    
    var sector: String
    
    var allCompanies: [Company] {
        CompaniesModel.getAllCompaniesFromSector(for: sector) ?? [Company(name: "ERROR", hash: "ERROR", arobase: "ERROR")]
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
                Image(allCompanies[selectedCompanyIndex].hash)
                    .resizable()
                    .scaledToFit()
                    .logoModifier()
                    .padding(5)
                Spacer()
                Divider()
                createButtons().padding(.top, 5)
                ProgressView(value: progression, total: 1.0).padding(5)
            }
        }
        .colorScheme(.light)
        .navigationBarTitle("\(sector.capitalized)", displayMode: .inline)
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

// MARK: - Custom Modifiers
    
struct LogoModifier: ViewModifier {
    func body(content: Content) -> some View {
        return //GeometryReader { geo in
            content
                .padding(5)
                //.frame(height: geo.size.height)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .shadow(color: .gray, radius: 2)
        }
    //}
}

extension View {
    func logoModifier() -> some View {
        return self.modifier(LogoModifier())
    }
}
