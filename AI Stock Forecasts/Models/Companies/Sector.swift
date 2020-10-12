import Foundation

struct Company {
    var name: String
    var hash: String
    var arobase: String
    var symbol: String {
        String(self.hash.dropFirst())
    }
}

struct Sector {
    var companies: [Company]
    var number: Int {
        return self.companies.count
    }
}

struct CompanyScore: Identifiable, Hashable {
    var id: UUID
    var name: String
    var symbol: String
    var hashScore: Int
    var arobaseScore: Int
    var newsScore: Int
    var totalScore: Double {
        Double(hashScore + arobaseScore + newsScore) / 1.2
    }
}
