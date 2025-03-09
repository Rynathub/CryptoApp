//
//  ViewCryptoControllerViewModel.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 25.02.2025.
//

import Foundation
import UIKit

class ViewCryptoControllerViewModel {
    
    
    
    let coin: Coin
    
    init(_ coin: Coin) {
        self.coin = coin
        
    }
    
    
    
    var rankLabel: String {
        return "Rank: \(self.coin.rank)"
    }
    var priceLabel: String {
        return "Price: $\(self.coin.pricingData.USD.price) USD"
    }
    var marketCapLabel: String {
        return "MarketCap: $\(self.coin.pricingData.USD.market_cap)"
    }
    var maxSupplyLabel: String {
        if let maxSupply = self.coin.maxSupply {
            return "MaxSupply: \(maxSupply)"
        }
        else {
            return "123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123"
        }
        
        
    }
}
