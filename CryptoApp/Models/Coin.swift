//
//  Coin.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 20.02.2025.
//

import Foundation

struct CoinArray:Decodable {
    let data: [Coin]
}

struct Coin:Decodable {
    
    let id: Int
    let name: String
    let maxSupply: Double?
    let rank: Int?
    let pricingData: PricingData
    
    var logoURL: URL? {
        return URL(string: "https://s2.coinmarketcap.com/static/img/coins/200x200/\(id).png")
    }
    
   
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case maxSupply = "max_supply"
        case rank = "cmc_rank"
        case pricingData = "quote"
    }
    
}
    
    
struct PricingData:Decodable {
    let USD: USD
}
struct USD:Decodable {
         let price: Double
        let market_cap: Double
    }
    
