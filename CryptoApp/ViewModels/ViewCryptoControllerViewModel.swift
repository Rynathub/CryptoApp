//
//  ViewCryptoControllerViewModel.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 25.02.2025.
//

import Foundation
import UIKit

class ViewCryptoControllerViewModel {
    
    var onImageLoaded: ((UIImage?) -> Void)?
    
    let coin: Coin
    
    init(_ coin: Coin) {
        self.coin = coin
        self.loadImage()
    }
    
    private func loadImage() {
        DispatchQueue.global().async {
            if let logoURL = self.coin.logoURL {
                let imageData = try? Data(contentsOf: logoURL)
                let logoImage = UIImage(data: imageData!)
                self.onImageLoaded?(logoImage)
            }
        }
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
