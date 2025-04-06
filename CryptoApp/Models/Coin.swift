//
//  Coin.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 20.02.2025.
//

import Foundation

struct CoinArray: Decodable {
    let data: [Coin]
}

struct Coin: Decodable {

    let id: Int
    let name: String
    let symbol: String
    let maxSupply: Double?
    let rank: Int?
    let fullAddress = "0xdAC17F958D2ee523a2206206994597C13D831ec7"
    let pricingData: PricingData

    var logoURL: URL? {
        return URL(
            string:
                "https://s2.coinmarketcap.com/static/img/coins/200x200/\(id).png"
        )
    }

    enum CodingKeys: String, CodingKey {
        case symbol = "symbol"
        case id = "id"
        case name = "name"
        case maxSupply = "max_supply"
        case rank = "cmc_rank"
        case pricingData = "quote"
    }
}


struct PricingData: Decodable {
    let USD: USD
}

struct USD: Decodable {
    let percent_change_24h: Double
    let price: Double
    let market_cap: Double
    let volume_24h: Double
}
