//
//  SelectionView.swift
//  Stock Forecasts
//
//  Created by Alexis on 9/20/20.
//

import SwiftUI
import Swifter
import CoreML

struct SelectionView: View {
    
    let swifter = Swifter(consumerKey: Keys.twitterKey, consumerSecret: Keys.twitterSecretKey)
    let model1 = try! TextClassifier1(configuration: MLModelConfiguration())
    let model2 = try! TextClassifier2(configuration: MLModelConfiguration())
    
    var sector: String
    
    var names: [String] {
        if sector == "all" {
            return CompaniesModel.names ?? ["ERROR"]
        } else {
            return CompaniesModel.getNames(for: sector) ?? ["ERROR"]
        }
    }
    
    var hashes: [String] {
        if sector == "all" {
            return CompaniesModel.hashes ?? ["ERROR"]
        } else {
            return CompaniesModel.getHashes(for: sector) ?? ["ERROR"]
        }
    }
    
    var arobases: [String] {
        if sector == "all" {
            return CompaniesModel.arobases ?? ["ERROR"]
        } else {
            return CompaniesModel.getArobases(for: sector) ?? ["ERROR"]
        }
    }
    
    @State private var arobaseScore: Int = 0
    @State private var hashScore: Int = 0
    @State private var selectedCompanyIndex: Int = 0
    @State private var selectedCompanyName: String = ""
    @State private var ready: Bool = false
    @State private var progression: Double = 0.0
    
    // MARK: - Screen body
    
    private func createBody() -> some View {
        return ZStack {
            Color.background.edgesIgnoringSafeArea(.vertical)
            VStack(alignment: .center, spacing: 10) {
                Text("Company Selection")
                    .font(.system(.title))
                    .fontWeight(.heavy)
                    .padding(.top, 5)
                Text("Select a company in the list below: ")
                    .font(.system(.subheadline))
                    .fontWeight(.regular)
                    .foregroundColor(Color.gray.opacity(0.9))
                createPicker()
                Spacer()
                Image(hashes[selectedCompanyIndex])
                    .resizable()
                    .scaledToFit()
                    .logoModifier()
                    .padding()
                Spacer()
                Divider()
                self.createButtons()
                VStack {
                    ProgressView("", value: progression, total: 1.0)
                }.padding(.all, 5)
            }
        }
    }
    
    var body: some View {
        return self.createBody()
            .navigationBarTitle("\(sector.capitalized)", displayMode: .inline)
    }
    
    // MARK: - Components
    
    private func createPicker() -> some View {
        return VStack {
            Picker(selection: $selectedCompanyIndex.animation(.easeInOut), label: Text("")) {
                ForEach(0 ..< names.count) {
                    Text(self.names[$0])
                }
            }
            .labelsHidden()
            HStack {
                Text("Your have selected: ")
                Text("\(names[selectedCompanyIndex])")
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
            }
        }
    }
    
    private func createButtons() -> some View {
        // ButtonStyled is a custom component which can be found in the Components folder
        let predictButton = ButtonStyled(text: "forecast", color: Color.black)
        let buttonBeforePredict = ButtonStyled(text: "not ready", color: Color.gray.opacity(0.5))
        let buttonAfterPredict = ButtonStyled(text: "results", color: Color.blue)
        
        return HStack(spacing: 16.0) {
            
            Button(action: {
                self.fetchTweets1(company: self.arobases[self.selectedCompanyIndex]) {
                    self.progression = 0.5
                    self.fetchTweets2(company: self.hashes[self.selectedCompanyIndex]) {
                        self.progression = 1.0
                        self.ready = true
                    }
                }
                self.selectedCompanyName = self.names[self.selectedCompanyIndex]
            }) {
                predictButton
            }
            
            NavigationLink(destination: ResultView(
                hashScore: self.$hashScore,
                arobaseScore: self.$arobaseScore,
                name: self.$selectedCompanyName,
                stock: String(hashes[selectedCompanyIndex].dropFirst())
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
    
    private func createSectionTitle(title: String, subtitle: String) -> some View {
        return Group {
            Text(title)
                .font(.system(.title))
                .fontWeight(.heavy)
            Text(subtitle)
                .font(.system(.headline))
                .fontWeight(.regular)
        }.padding()
    }
    
    // MARK: - functions
    
    func fetchTweets1(company: String, completion: @escaping () -> Void) {
        
        swifter.searchTweet(
            using: company,
            lang: "en",
            count: 100,
            tweetMode: .extended,
            success: { (results, metadata) in
                self.progression = 0.2
                print(self.progression)
                var tweets = [TextClassifier1Input]()
                for i in 0...99 {
                    if let tweet = results[i]["full_text"].string {
                        tweets.append(TextClassifier1Input(text: tweet))
                    }
                }
                self.makePrediction1(with: tweets) {
                    self.progression = 0.4
                    print(self.progression)
                }
                print("fetchtweets done")
                completion()
        }) { (error) in
            print("There was an error with the Twitter API: --> ", error)
            completion()
        }
    }
    
    func fetchTweets2(company: String, completion: @escaping () -> Void) {
        
        swifter.searchTweet(
            using: company,
            lang: "en",
            count: 100,
            tweetMode: .extended,
            success: { (results, metadata) in
                self.progression = 0.6
                print(self.progression)
                var tweets = [TextClassifier2Input]()
                for i in 0...99 {
                    if let tweet = results[i]["full_text"].string {
                        tweets.append(TextClassifier2Input(text: tweet))
                    }
                }
                self.makePrediction2(with: tweets) {
                    self.progression = 0.8
                    print(self.progression)
                }
                print("fetchtweets done")
                completion()
        }) { (error) in
            print("There was an error with the Twitter API: --> ", error)
            completion()
        }
    }

    func makePrediction1(with tweets: [TextClassifier1Input], onCompletionPrediction: @escaping () -> Void) {
        do {
            let predictions = try self.model1.predictions(inputs: tweets)
            var sentimentScore = 0
            for pred in predictions {
                switch pred.label {
                case "pos":
                    sentimentScore += 1
                case "neg":
                    sentimentScore -= 1
                default:
                    break
                }
            }
            arobaseScore = sentimentScore
            print("ML prediction done")
            onCompletionPrediction()
        } catch {
            print("There was an error with the ML model: --> ", error)
            onCompletionPrediction()
        }
    }
    
    func makePrediction2(with tweets: [TextClassifier2Input], onCompletionPrediction: @escaping () -> Void) {
        do {
            let predictions = try self.model2.predictions(inputs: tweets)
            var sentimentScore = 0
            for pred in predictions {
                switch pred.label {
                case "positive":
                    sentimentScore += 1
                case "negative":
                    sentimentScore -= 1
                default:
                    break
                }
            }
            hashScore = sentimentScore
            print("ML prediction done")
            onCompletionPrediction()
        } catch {
            print("There was an error with the ML model: --> ", error)
            onCompletionPrediction()
        }
    }
    
}

// MARK: - Custom Modifiers
struct LogoModifier: ViewModifier {
    func body(content: Content) -> some View {
        return //GeometryReader { geo in
            content
                .padding(10)
                //.frame(height: geo.size.height)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .shadow(color: .gray, radius: 2)
        }
    //}
}

extension View {
    func logoModifier() -> some View {
        return self.modifier(LogoModifier())
    }
}
