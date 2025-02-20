//
//  Coin.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 20.02.2025.
//

import Foundation

struct Coin {
     
    let id: Int
    let name: String
    let max_supply: Int?
    let cmc_rank: Int
    let quote: Quote
    
    struct Quote {
        let USD: USD
        
        struct USD {
             let price: Double
            let market_cap: Double
        }
    }
}

extension Coin {
    
    func getMockArray() -> [Coin] {
        return [
            Coin(id: 1, name: "XRP", max_supply: 200, cmc_rank: 1, quote: Quote(USD:Quote.USD(price: 5000, market_cap: 100000))),
            Coin(id: 53, name: "Luna", max_supply: nil, cmc_rank: 4, quote: Quote(USD:Quote.USD(price: 1250, market_cap: 300000))),
            Coin(id: 6, name: "Solar", max_supply: nil, cmc_rank: 19, quote: Quote(USD:Quote.USD(price: 15000, market_cap: 346000)))
        ]
    }
}
