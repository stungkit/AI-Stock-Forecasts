//
//  NetworkManager.swift
//  AI Stock Forecasts
//
//  Created by Alexis on 9/22/20.
//

import Foundation

class NetworkManager {
    
    var news = [Article]()
    
    func fetchData(company: String) {
        let key = Keys.newsApiKey
        if let url = URL(string: "https://newsapi.org/v2/everything?q=\(company)&apiKey=\(key)") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(News.self, from: safeData)
                            self.news = results.articles
                            
                        } catch {
                            print("ERROR NEWS API --->>> ", error.localizedDescription)
                        }
                    }
                }
            }
            task.resume()
        }
        
    }
}
