import SwiftUI
import Combine

struct StockChart: View {
    
    @ObservedObject var stocks = Stocks(stockSymbol: "....")
    
    var name: String
    
    init(name: String) {
        self.name = name
        self.stocks = Stocks(stockSymbol: name)
    }
    
    var body: some View {
        return VStack {
            Text("Stock chart for the last day")
                .font(.system(.subheadline))
                .fontWeight(.regular)
                .foregroundColor(Color.gray.opacity(0.9))
                .padding(.bottom, 5)
            
            HStack(alignment: .center, spacing: 0) {
                Text("Current stock price for ")
                Text("\(name)")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Text(": $\(stocks.currentPrice)")
            }
            LineView(data: stocks.prices)
        }
    }
}

class Stocks : ObservableObject{
    
    @Published var prices = [Double]()
    @Published var currentPrice = "..."
    
    var cancellable : Set<AnyCancellable> = Set()
    var stockSymbol: String
    var numberOfFetches: Int = 0
    
    init(stockSymbol: String) {
        self.stockSymbol = stockSymbol
        fetchStockPrice()
        print(numberOfFetches)
    }
    
    var urlBase: String {
        "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(stockSymbol)&apikey=\(Keys.alphaVantageKey)"
    }
    
    let urlTest = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=IBM&apikey=demo"
    
    
    func fetchStockPrice() {
        numberOfFetches += 1
        URLSession.shared.dataTaskPublisher(for: URL(string: "\(urlBase)")!)
            .map { output in
                return output.data
            }
            .decode(type: StocksDaily.self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: { _ in
                    print("Alpha Vantage call completed")
                },
                receiveValue: { value in
                    var stockPrices = [Double]()
                    
                    let orderedDates =  value.timeSeriesDaily?.sorted{
                        guard let d1 = $0.key.stringDate, let d2 = $1.key.stringDate else { return false }
                        return d1 < d2
                    }
                    
                    guard let stockData = orderedDates else {return}
                    
                    for (_, stock) in stockData{
                        if let stock = Double(stock.close){
                            if stock > 0.0{
                                stockPrices.append(stock)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async{
                        self.prices = stockPrices
                        self.currentPrice = stockData.last?.value.close ?? "..."
                    }
                })
            .store(in: &cancellable)
    }
}


struct StockPrice : Codable{
    let open: String
    let close: String
    let high: String
    let low: String
    
    private enum CodingKeys: String, CodingKey {
        
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
    }
}

struct StocksDaily : Codable {
    let timeSeriesDaily: [String: StockPrice]?
    
    private enum CodingKeys: String, CodingKey {
        case timeSeriesDaily = "Time Series (Daily)"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        timeSeriesDaily = try (values.decodeIfPresent([String : StockPrice].self, forKey: .timeSeriesDaily))
    }
}

extension String {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var stringDate: Date? {
        return String.shortDate.date(from: self)
    }
}

