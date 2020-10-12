import SwiftUI
import Swifter
import CoreML

struct TopBottomView: View {
    
    let swifter = Swifter(consumerKey: Keys.twitterKey, consumerSecret: Keys.twitterSecretKey)
    let model1 = Model1()
    let model2 = Model2()
    
    var sector: String
    var type: ArrowType
    
    var allCompanies: Sector {
        Sector(companies: CompaniesModel.getSector(for: sector) ?? [Company(name: "ERROR", hash: "ERROR", arobase: "ERROR")])
    }
    
    @State private var companyScoreArray: [CompanyScore] = [CompanyScore]()
    @State private var ready: Bool = false
    @State private var progression: Double = 0.0
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.vertical)
            VStack {
                SectionTitle(
                    title: type == .up ? "Top 5 companies" : "Bottom 5 companies",
                    subTitle: type == .up ? "Best stock outcomes for the sector" : "Worst stock outcomes for the sector"
                )
                Spacer()
                Arrows(type: type)
                Spacer()
                Divider()
                createButtons()
                ProgressView("", value: progression, total: 1.0).padding(5)
            }
        }
        .colorScheme(.light)
        .navigationBarTitle("\(sector.capitalized)", displayMode: .inline)
    }
    
    // MARK: - Networking functions
    
    func fetchTweets1(company: String, completion: @escaping (Int) -> Void) {
        
        swifter.searchTweet(
            using: company,
            lang: "en",
            count: 50,
            tweetMode: .extended,
            success: { (results, metadata) in
                print(self.progression)
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
                print(self.progression)
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
    
    private func createButtons() -> some View {
        // ButtonStyled is a custom component which can be found in the SharedComponents folder
        let predictButton = ButtonStyled(text: "forecast", color: Color.black)
        let buttonBeforePredict = ButtonStyled(text: "not ready", color: Color.gray.opacity(0.5))
        let buttonAfterPredict = ButtonStyled(text: "results", color: Color.blue)
        
        return HStack(spacing: 16.0) {
            
            Button(action: {
                for company in allCompanies.companies {
                    fetchTweets1(company: company.arobase) { arobaseScore in
                        fetchTweets2(company: company.hash) { hashScore in
                            fetchData(company: company.symbol) { newsScore in
                                progression += 1.0 / Double(allCompanies.number)
                                companyScoreArray.append(CompanyScore(
                                    id: UUID(),
                                    name: company.name,
                                    hashScore: hashScore,
                                    arobaseScore: arobaseScore,
                                    newsScore: newsScore
                                ))
                                companyScoreArray.sort {
                                    $0.totalScore > $1.totalScore
                                }
                                ready = (allCompanies.number == companyScoreArray.count)
                            }
                        }
                    }
                }
            }) {
                predictButton
            }
            
            NavigationLink(destination: TopBottomResultsView(
                sector: sector,
                companyScoreArray: companyScoreArray,
                type: type
            )) {
                ready ? buttonAfterPredict : buttonBeforePredict
            }
            .disabled(!ready)
            .simultaneousGesture(TapGesture().onEnded({
                self.ready = false
                self.progression = 0.0
            }))
        }
    }
    
}
