import Foundation

struct CompanyScore: Identifiable, Hashable {
    var id: UUID
    var name: String
    var symbol: String
    var hashScore: Int
    var arobaseScore: Int
    var newsScore: Int
    var totalScore: Double {
        Double(hashScore) * 0.5 + Double(arobaseScore) * 0.5 + Double(newsScore) * 2
    }
}
