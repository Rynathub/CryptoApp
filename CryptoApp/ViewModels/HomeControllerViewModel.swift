//
//  HomeControllerViewModel.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 04.03.2025.
//

import Foundation
import UIKit

class HomeControllerViewModel {
    
    var coinsUpdated: (() -> Void)?
    var onErrorMessage: ((CoinServiceError) -> Void)?
    
    private(set) var allCoins: [Coin] = [] {
        didSet {
            self.coinsUpdated?()
        }
    }
    
    private(set) var filteredCoins : [Coin] = []
    
    init() {
        self.fetchCoins()
    }

    
    func fetchCoins() {
        let endpoint = EndPoints.fetchCoins()
        
        CoinService.shared.performRequest(endpoint: endpoint,type: CoinArray.self) { [weak self] result in
            switch result {
            case .success(let coins):
                print("Amount of fetched coins: \(coins.data.count)")
                self?.allCoins = coins.data
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

extension HomeControllerViewModel {
    func inSearchMode(_ searchController: UISearchController) -> Bool{
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        return isActive && !searchText.isEmpty
    }   
    func updateSearchController(searchBarText: String?) {
        // If `searchBarText` is nil or empty after lowercasing, just show all coins
        guard let searchText = searchBarText?.lowercased(), !searchText.isEmpty else {
            self.filteredCoins = allCoins
            self.coinsUpdated?()
            return
        }

        // Filter
        self.filteredCoins = allCoins.filter {
            $0.name.lowercased().contains(searchText)
        }

        // Sort
        self.filteredCoins = filteredCoins.sorted {
            let lhs = $0.name.lowercased()
            let rhs = $1.name.lowercased()

            let lhsHasPrefix = lhs.hasPrefix(searchText)
            let rhsHasPrefix = rhs.hasPrefix(searchText)

            switch (lhsHasPrefix, rhsHasPrefix) {
            case (true, false):  return true
            case (false, true):  return false
            default:             return lhs < rhs
            }
        }

        self.coinsUpdated?()
    }
}
