import SwiftUI
import Charts

struct StockChart: View {
    
    //@ObservedObject var stocks = Stocks(stockSymbol: "....")
    var stockSymbol: String
    
    @State var stockPrices: [Double] = [Double]()
    
    func createBarChart(stocks: [Double]) -> some View {
        var stockEntries = [BarChartDataEntry]()
        for i in 0..<stocks.count {
            stockEntries.append(BarChartDataEntry(x: Double(i), y: stocks[i]))
        }
        return Bar(entries: stockEntries)
        
    }
    
    var body: some View {
        return VStack {
            Text("Daily stock chart for the last month")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
            
            HStack(alignment: .center, spacing: 0) {
                Text("Current stock price for ")
                    .font(.subheadline)
                Text("\(stockSymbol)")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                if !stockPrices.isEmpty {
                    let roundedPrice = String(format: "%.2f", stockPrices.last!)
                    Text(": $\(roundedPrice)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                } else {
                    Text("...")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
            }
            if stockPrices.isEmpty {
                ProgressView("loading data...")
            } else {
                createBarChart(stocks: stockPrices).frame(height: 200)
            }
        }.onAppear { YahooFinance.getHistoricalData(stockSymbol: stockSymbol) { results in
            stockPrices = results
        }
        
        }
    }
}


