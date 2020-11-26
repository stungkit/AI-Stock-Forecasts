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
        var results = CompaniesModel.getAllCompaniesFromSector(for: sector) ?? [Company(id: "ERROR", name: "ERROR", arobase: "ERROR", sector: "ERROR", custom: false)]
        for custom in fetchRequest.wrappedValue {
            results.append(Company(id: custom.wrappedId, name: custom.wrappedName, arobase: custom.wrappedArobase, sector: custom.wrappedSector, custom: true))
        }
        return results
    }
    
    // MARK: - States
    
    @State private var selectedCompany = "Test"
    @State private var ready: Bool = false
    @State private var progression: Double = 0.0
    
    // MARK: - Screen body
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.vertical)
            VStack(alignment: .center, spacing: 5) {
                SectionTitle(title: "Company Selection", subTitle: "Select a company in the list below: ")
                createPicker()
                Spacer()
                createLogoImage(hash: allCompanies[selectedCompanyIndex].custom ? "custom" : allCompanies[selectedCompanyIndex].hash)
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
            Picker(selection: $selectedCompany.animation(.easeInOut), label: Text("")) {
                ForEach(allCompanies) {
                    Text($0.name)
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
                            selectedCompany.updateArobaseScore(newArobaseScore: arobaseScore)
                            selectedCompany.updateHashScore(newHashScore: hashScore)
                            selectedCompany.updateNewsScore(newNewsScore: newsScore)
                            progression = 1.0
                            ready = true
                            print(selectedCompany.name)
                            print(selectedCompany.arobaseScore)
                            print(selectedCompany.hashScore)
                            print(selectedCompany.newsScore)
                            print("-----------------")
                            allCompanies[selectedCompanyIndex].updateArobaseScore(newArobaseScore: 100)
                            print(allCompanies[selectedCompanyIndex].arobaseScore)
                            print(selectedCompanyIndex)
                        }
                    }
                }
            }) {
                predictButton
            }
            
            NavigationLink(destination: ResultView(company: allCompanies[selectedCompanyIndex])) {
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
