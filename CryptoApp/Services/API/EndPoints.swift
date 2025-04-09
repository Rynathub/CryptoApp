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
    case fetchOHLCVHistorical(id: Int,url: String = "/v2/cryptocurrency/ohlcv/historical")
    case fetchMetaData(id: Int,url: String = "/v2/cryptocurrency/info")
   
    

    
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
        
        case .fetchOHLCVHistorical(_ ,url: let url):
            return url
            
        case .fetchMetaData(_, url: let url):
            return url
        }
    }
    
    var method: HTTPMethod {
            switch self {
            case .fetchCoins:
                return .get
                
            case .fetchOHLCVHistorical:
                return .get
                
            case .fetchMetaData:
                return .get
            }
        }
    
     var headers:HTTPHeaders {
        switch self {
        case .fetchCoins:
            return [
                "X-CMC_PRO_API_KEY": Constants.API_KEY,
                
            ]
        
        case .fetchOHLCVHistorical:
            return [
                "X-CMC_PRO_API_KEY": Constants.API_KEY,
            ]
            
        case .fetchMetaData:
            return [
                "X-CMC_PRO_API_KEY": Constants.API_KEY,
            ]
        }
    }
    
     var queryItems: [String: Any] {
        switch self {
        case .fetchCoins:
            return [
                        "limit": "75",
                        "sort": "market_cap",
                        "convert": "USD",
                        "aux": "cmc_rank,max_supply,circulating_supply,total_supply",
            ]
        
        case .fetchOHLCVHistorical(let id, _):
                    return [
                        "id": id,
                        "time_period": "hourly",
                        "interval" : "2h",
                        "time_end" : TimeService.getTimeForRequest(),
                        "count" : "14",
                        "convert": "USD"
                    ]
        case .fetchMetaData(id: let id, url: _):
            return [
                "id" : id,
                "aux" : "urls"
            ]
        }
        
    }
}

struct TimeService {
   static func getTimeForRequest() -> String {
       let timeEnd = Date()
       let formatter = ISO8601DateFormatter()
       let tineEndString = formatter.string(from: timeEnd)
       return tineEndString
    }
   
}
