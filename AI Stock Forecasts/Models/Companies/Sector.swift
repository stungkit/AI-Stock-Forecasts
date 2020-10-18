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
