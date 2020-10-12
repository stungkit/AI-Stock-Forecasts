import Foundation
import Swifter


struct Networking {
    
    let swifter = Swifter(consumerKey: Keys.twitterKey, consumerSecret: Keys.twitterSecretKey)
    let model1 = Model1()
    let model2 = Model2()
    
    func fetchTweets1(company: String, completion: @escaping (Int) -> Void) {
        
        swifter.searchTweet(
            using: company,
            lang: "en",
            count: 50,
            tweetMode: .extended,
            success: { (results, metadata) in
                var tweets = [TextClassifier1Input]()
                for i in 0...49 {
                    if let tweet = results[i]["full_text"].string {
                        tweets.append(TextClassifier1Input(text: tweet))
                    }
                }
                let score = model1.makePrediction1(with: tweets)
                print("fetchtweets done")
                completion(score)
            }) { (error) in
            print("There was an error with the Twitter API: --> ", error)
            completion(0)
        }
    }
    
    func fetchTweets2(company: String, completion: @escaping (Int) -> Void) {
        
        swifter.searchTweet(
            using: company,
            lang: "en",
            count: 50,
            tweetMode: .extended,
            success: { (results, metadata) in
                var tweets = [TextClassifier2Input]()
                for i in 0...49 {
                    if let tweet = results[i]["full_text"].string {
                        tweets.append(TextClassifier2Input(text: tweet))
                    }
                }
                let score = model2.makePrediction2(with: tweets)
                print("fetchtweets done")
                completion(score)
            }) { (error) in
            print("There was an error with the Twitter API: --> ", error)
            completion(0)
        }
    }
    
    func fetchData(company: String, completion: @escaping (Int) -> Void) {
        let key = Keys.newsApiKey
        var titles = [TextClassifier1Input]()
        if let url = URL(string: "https://newsapi.org/v2/everything?q=\(company)&apiKey=\(key)") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(News.self, from: safeData)
                            for article in results.articles {
                                titles.append(TextClassifier1Input(text: article.title))
                            }
                            let score = model1.makePrediction1(with: titles)
                            completion(score)
                        } catch {
                            print("ERROR NEWS API --->>> ", error.localizedDescription)
                            completion(0)
                        }
                    }
                }
            }
            task.resume()
        }
        
    }
}
