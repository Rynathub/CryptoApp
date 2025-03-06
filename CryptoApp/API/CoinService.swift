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
        AF.request(url,method: endpoint.method,parameters: endpoint.queryItems,headers: endpoint.headers).validate().response { response in
            if let error = response.error {
                completion(.failure(CoinServiceError.unknown(error.localizedDescription)))
            }
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch let err {
                    completion(.failure(CoinServiceError.decodingError()))
                    print(err.localizedDescription)
                }
            } else {
                completion(.failure(CoinServiceError.unknown()))
            }
            
        }
        
    }
}

