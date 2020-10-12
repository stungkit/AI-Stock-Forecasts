import Foundation

struct News: Decodable {
    // 20 items
    let articles: [Article]
}

struct Article: Decodable {
    let title: String
}
