    //
    //  ViewCryptoControllerViewModel.swift
    //  CryptoApp
    //
    //  Created by Rynat Shakirov on 25.02.2025.
    //

    import Foundation
    import DGCharts

    class ViewCryptoControllerViewModel {
        
        var dataEntries: [ChartDataEntry] = [] {
            didSet {
                onChartDataReady?()
            }
        }
        
        var onChartDataReady: (() -> Void)?
        private var chartData: OHLCVLatest?
        private var onChartError : ((CoinServiceError) -> Void)?
        
        private var coinMetaData: CoinMeta?
        
        
        private func formatCoinPrice() -> String {
            if self.coin.pricingData.USD.price >= 5 {
                    return "%.2f"
            } else {
                    return "%f"
            }
        }
        
        private func shortenedAddress(_ address: String) -> String {
            guard address.count > 10 else {return address}
            let leftSide = address.prefix(6)
            let rightSide = address.suffix(4)
            
            return "\(leftSide)...\(rightSide)"
        }
        
        private func formatLargeNumbers(_ value: Double) -> String {
            if value >= 1_000_000_000 {
                return String(format: "%.2fB", value / 1_000_000_000)
            }
            else if value >= 1_000_000 {
                return String(format: "%.2fM", value / 1_000_000)
                }
            else if value >= 1000 {
                return String(format: "%.2fK", value / 1000)
            }
            return String(value)
        }
        
        
        func setData() {
            guard let historicalData = chartData else { return }
            let dataFormatter = ISO8601DateFormatter()
            dataFormatter.formatOptions = [
                .withInternetDateTime,
                .withFractionalSeconds
            ]
            dataFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            var newEntries: [ChartDataEntry] = []
            
            for quoteContainer in historicalData.data.quotes {
                print("timeOpen raw string: '\(quoteContainer.timeOpen)'")
                if let date = dataFormatter.date(from: quoteContainer.timeOpen) {
                    let xValue = date.timeIntervalSince1970
                    let yValue = quoteContainer.quote.usd.close
                    newEntries.append(ChartDataEntry(x: xValue, y: yValue))
                } else {
                    print("Failed to parse date for: \(quoteContainer.timeOpen)")
                }
                
                
                // Sort entries by timestamp
                newEntries.sort { $0.x < $1.x }
                
                // Important: Make sure we have entries
                if !newEntries.isEmpty {
                    self.dataEntries = newEntries
                    print("Chart data loaded: \(newEntries.count) points")
                } else {
                    print("No data points were created")
                }
            }
        }
      //MARK: - NetWork requests
        
        private func fetchHistoricalData() {
           
            CoinService.shared.performRequest(endpoint: .fetchOHLCVHistorical(id: self.coin.id), type: OHLCVLatest.self) { [weak self] result in
                switch result {
                case .success(let data):
                    print("Chart data successufully fetched")
                    self?.chartData = data
                    self?.setData()
                case .failure(let error):
                    guard let serviceError = error as? CoinError else {
                        let callBackError = CoinServiceError.unknown(error.localizedDescription)
                        print("Can't decode service error ralating to chart data")
                        self?.onChartError?(callBackError)
                        return
                    }
                    print(serviceError)
                }
            
            }
        }
        
        private func fetchMetaData() {
            CoinService.shared.performRequest(endpoint: .fetchMetaData(id: self.coin.id), type: CoinMeta.self) { [weak self] result in
                switch result {
                case .success(let data):
                print("Meta data successfully fetched")
                    self?.coinMetaData = data
                case .failure(let error):
                    guard let serviceError = error as? CoinError else {
                        let unknownError = CoinServiceError.unknown(error.localizedDescription)
                        print("Can't decode service error ralating to meta data")
                        return print(unknownError.localizedDescription)
                    }
                    print(serviceError)
                }
            }
        }
        
        
        //MARK: - Data preparation for View
        let coin: Coin
        
        init(_ coin: Coin) {
            self.coin = coin
            self.fetchHistoricalData()
            self.fetchMetaData()
           
        }
        
        var tokenAddress: String {
            let fullAddress = "0xdAC17F958D2ee523a2206206994597C13D831ec7"
            return shortenedAddress(fullAddress)
        }
        
        var tokenDecimal: Int {
            let range = 8...16
            let evenNumbers = range.filter { $0 % 2 == 0 }
            let number = evenNumbers.randomElement() ?? 6
            return number
        }
        
        var webSiteLink: String? {
            if let webSiteUrls = coinMetaData?.data["\(coin.id)"]?.urls.website,!webSiteUrls.isEmpty {
                return webSiteUrls.first
            }
            return nil
        }
        
        var nameSymLabel: String {
            return "\(self.coin.name) (\(self.coin.symbol))"
        }
        var nameSymLabel2: String {
            return " 0 \(self.coin.symbol)"
        }
        
        var isPresentPositiveChange: Bool {
            return self.coin.pricingData.USD.percent_change_24h >= 0
        }
        
        var percentChangeLabel: String {
            
            return String(format: "(%.2f%%)",self.coin.pricingData.USD.percent_change_24h)
        }
        
        var changedPriceLabel: String {
            let changedPrice = self.coin.pricingData.USD.price * (self.coin.pricingData.USD.percent_change_24h / 100)
            
            let format = self.formatCoinPrice()
            
            if changedPrice < 0 {
                return String(format: "-$\(format)", abs(changedPrice))
                } else {
                    return String(format: "$\(format)", changedPrice)
                }
        }
        
        var rankLabel: String {
            return "\(self.coin.rank ?? 0)"
        }
        var priceLabel: String {
            let format = self.formatCoinPrice()
            
            if self.coin.pricingData.USD.price < 0 {
                
                return String(format: "-\(format)", abs(self.coin.pricingData.USD.price))
                
                } else {
                    
                    return String(format: "$\(format)", self.coin.pricingData.USD.price)
                }
           
        }
        var volumeLabel: String {
            return formatLargeNumbers(self.coin.pricingData.USD.volume_24h)
        }
        
        var marketCapLabel: String {
            return formatLargeNumbers(self.coin.pricingData.USD.market_cap)

        }
        var maxSupplyLabel: String? {
            guard let maxSupply = self.coin.maxSupply else {
                let sym = "\u{221E}"
                return sym
            }
            return formatLargeNumbers(maxSupply)
        }
    }


