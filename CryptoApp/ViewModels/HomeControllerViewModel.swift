//
//  HomeControllerViewModel.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 04.03.2025.
//

import Foundation

class HomeControllerViewModel {
    
    var coinsUpdated: (() -> Void)?
    var onErrorMessage: ((CoinServiceError) -> Void)?
    
    private(set) var coins: [Coin] = [] {
        didSet {
            self.coinsUpdated?()
        }
    }
    
    init() {
        self.fetchCoins()
    }

    
    func fetchCoins() {
        let endpoint = EndPoints.fetchCoins()
        
        CoinService.shared.performRequest(endpoint: endpoint,type: CoinArray.self) { [weak self] result in
            switch result {
            case .success(let coins):
                print("Amount of fetched coins: \(coins.data.count)")
                self?.coins = coins.data
            case .failure(let error):
                guard let serviceError = error as? CoinServiceError else {
                    
                    let fallbackError = CoinServiceError.unknown(error.localizedDescription)
                            self?.onErrorMessage?(fallbackError)
                    return
                }

                self?.onErrorMessage?(serviceError)
            }
        }
    }
}
