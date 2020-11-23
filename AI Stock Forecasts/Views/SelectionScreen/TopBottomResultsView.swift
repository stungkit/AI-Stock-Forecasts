import SwiftUI

struct TopBottomResultsView: View {
    var sector: String
    var companyScoreArray: [CompanyScore]
    var type: ArrowType
    
    var top5Array: Array<CompanyScore>.SubSequence {
        companyScoreArray.prefix(5)
    }
    var bottom5Array: Array<CompanyScore>.SubSequence {
        companyScoreArray.suffix(5)
    }
    
    var title: String {
        type == .up ? "Top 5" : "Bottom 5"
    }
    
    var body: some View {
        Form {
            Section(header: Text("\(title) companies")) {
                ForEach(type == .up ? top5Array : bottom5Array) { element in
                    NavigationLink(destination: ResultView(
                        hashScore: element.hashScore,
                        arobaseScore: element.arobaseScore,
                        newsScore: element.newsScore,
                        name: element.name,
                        totalScore: element.totalScore,
                        stockSymbol: element.symbol
                    )) {
                        HStack {
                            Text(element.name)
                            Spacer()
                            Text("score: \(Int(element.totalScore))")
                        }.padding()
                    }
                }
            }
        }
        .colorScheme(.light)
        .navigationTitle("\(sector.capitalized)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

