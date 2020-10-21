import SwiftUI
import Charts

struct StockChart: View {
    
    @ObservedObject var stocks = Stocks(stockSymbol: "....")
    
    var name: String
    
    init(name: String) {
        self.name = name
        self.stocks = Stocks(stockSymbol: name)
    }
    
    func createBarChart(stocks: [Double]) -> some View {
        var stockEntries = [BarChartDataEntry]()
        for i in 0..<stocks.count {
            stockEntries.append(BarChartDataEntry(x: Double(i), y: stocks[i]))
        }
        return Bar(entries: stockEntries)
        
    }
    
    var body: some View {
        return VStack {
            Text("Stock chart for the 100 last days")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
            
            HStack(alignment: .center, spacing: 0) {
                Text("Current stock price for ")
                    .font(.subheadline)
                Text("\(name)")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Text(": $\(stocks.currentPrice)")
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            if stocks.prices.isEmpty {
                ProgressView("loading data...")
            }
            else {
                createBarChart(stocks: stocks.prices).frame(height: 200)
            }
        }
    }
}


