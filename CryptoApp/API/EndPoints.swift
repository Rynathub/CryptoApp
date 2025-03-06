//
//  EndPoints.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 28.02.2025.
//

import Foundation
import Alamofire

enum EndPoints {
    case fetchCoins(url: String = "/v1/cryptocurrency/listings/latest")
    
   
    

    
    // MARK: - Constructing an URL

     var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.baseURL
        components.port = Constants.port
        components.path = self.path
        return components.url
    }
    
     private var path: String {
        switch self {
        case .fetchCoins(url: let url):
            return url
        }
    }
    var method: HTTPMethod {
            switch self {
            case .fetchCoins:
                return .get
            }
        }
    
     var headers:HTTPHeaders {
        switch self {
        case .fetchCoins:
            return [
                "X-CMC_PRO_API_KEY": Constants.API_KEY,
                
            ]
        }
    }
    
     var queryItems: [String: Any] {
        switch self {
        case .fetchCoins:
            return [
                        "limit": "150",
                        "sort": "market_cap",
                        "convert": "USD",
                        "aux": "cmc_rank,max_supply,circulating_supply,total_supply"
            ]
        }
        
    }
}
