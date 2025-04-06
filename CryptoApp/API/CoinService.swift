//
//  CoinService.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 03.03.2025.
//

import Foundation
import Alamofire

enum CoinServiceError: Error {
    case serverError(CoinError)
    case unknown(String = "An unknown error occured.")
    case decodingError(String = "Error parsing server response.")
}

class CoinService {
    static let shared = CoinService()
    private init() {}
    
    func performRequest<T:Decodable>(endpoint:EndPoints,type:T.Type,completion: @escaping (Result<T,Error>) -> Void)  {
        guard let url = endpoint.url else {
            completion(.failure(CoinServiceError.unknown("Invalid request.")))
            return
        }
        AF.request(url,method: endpoint.method,parameters: endpoint.queryItems,headers: endpoint.headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch let err{
                    print("Decoding error :\(err.localizedDescription)")
                    completion(.failure(CoinServiceError.decodingError()))
                }
            case .failure:
                if let data = response.data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let coinError = try decoder.decode(CoinError.self, from: data)
                        completion(.failure(coinError))
                    } catch {
                        completion(.failure(CoinServiceError.unknown("Failed to decode server error")))
                    }
                } else {
                    completion(.failure(CoinServiceError.unknown("")))
                }
            }
        }
    }
}
