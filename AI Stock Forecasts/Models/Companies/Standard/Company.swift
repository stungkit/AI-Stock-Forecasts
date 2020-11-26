import Foundation

struct Company {
    var name: String
    var hash: String
    var arobase: String
    var symbol: String {
        String(self.hash.dropFirst())
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
        Double(hashScore) * 0.5 + Double(arobaseScore) * 0.5 + Double(newsScore) * 2
    }
}

class Company2: Identifiable {
// may be used later to harmonize datastructures
    let id: String
    let name: String
    let arobase: String
    let sector: String
    let custom: Bool
    var hashScore: Int = 0
    var arobaseScore: Int = 0
    var newsScore: Int = 0

    var hash: String {
        "#\(id)"
    }
    
    var totalScore: Double {
        Double(hashScore) * 0.5 + Double(arobaseScore) * 0.5 + Double(newsScore) * 2
    }
    
    init(id: String, name: String, arobase: String, sector: String, custom: Bool) {
        self.id = id
        self.name = name
        self.arobase = arobase
        self.sector = sector
        self.custom = custom
    }
}

enum Sector: String, CaseIterable {
    case industrials
    case healthcare
    case technology
    case telecomMedia = "telecom-media"
    case goods
    case energy
    case financials
    case all
}
