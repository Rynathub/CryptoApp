//
//  OHLCVLatest.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 22.03.2025.
//

import Foundation


struct OHLCVLatest: Decodable {
    let data: CoinOHLCV
}

struct CoinOHLCV: Decodable {
      let quotes: [QuotesContainer]
}

struct QuotesContainer: Decodable {
    let timeOpen: String
    let timeClose: String
    let timeHigh: String
    let timeLow: String
    let quote: Quote
    
    private enum CodingKeys: String,CodingKey{
        case timeOpen = "time_open"
        case timeClose = "time_close"
        case timeHigh = "time_high"
        case timeLow = "time_low"
        case quote
    }
}

struct Quote: Decodable {
    let usd: OHLCV
    
    private enum CodingKeys: String,CodingKey{
        case usd = "USD"
    }
}
struct OHLCV: Decodable {
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double
    
    private enum CodingKeys: String,CodingKey{
        case open,high,low,close,volume
    }
}
