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

class CompanyScore2: ObservableObject {
    
    @Published var name: String
    @Published var hash: String
    @Published var arobase: String

    @Published var hashScore: Int
    @Published var arobaseScore: Int
    @Published var newsScore: Int
    
    var symbol: String {
        String(self.hash.dropFirst())
    }
    
    var totalScore: Double {
        Double(hashScore) * 0.5 + Double(arobaseScore) * 0.5 + Double(newsScore) * 2
    }
    
    init(name: String, hash: String, arobase: String, hashScore: Int, arobaseScore: Int, newsScore: Int) {
        self.name = name
        self.hash = hash
        self.arobase = arobase
        self.hashScore = hashScore
        self.arobaseScore = arobaseScore
        self.newsScore = newsScore
    }
}
