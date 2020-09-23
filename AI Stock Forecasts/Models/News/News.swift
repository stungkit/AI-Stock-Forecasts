//
//  News.swift
//  AI Stock Forecasts
//
//  Created by Alexis on 9/22/20.
//

import Foundation

struct News: Decodable {
    // 20 items
    let articles: [Article]
}

struct Article: Decodable {
    let title: String
}
