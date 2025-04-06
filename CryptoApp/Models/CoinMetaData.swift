//
//  CoinMetaData.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 31.03.2025.
//

import Foundation


struct CoinMeta: Decodable {
    let data: [String : CoinMetaData]
}

struct CoinMetaData: Decodable {
    let urls: MetaLinks
    
}

struct MetaLinks: Decodable {
    let website : [String]
}
