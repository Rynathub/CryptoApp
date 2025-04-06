//
//  ViewController.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 20.02.2025.
//

import UIKit

class HomeController: UIViewController {

    private let viewModel: HomeControllerViewModel
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor(
            red: 21 / 255.0, green: 22 / 255.0, blue: 24 / 255.0, alpha: 1.0)
        tv.register(CoinCell.self, forCellReuseIdentifier: CoinCell.identifier)
        return tv
    }()
    
    init(_ viewModel: HomeControllerViewModel = HomeControllerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchController()
        self.setupUI()
        
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        viewModel.coinsUpdated = { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        viewModel.onErrorMessage = {  error in
                // Show an alert or log the error
                print("Error: \(error)")
            }
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.showsBookmarkButton = true
        self.searchController.searchBar.setImage(UIImage(systemName: "line.horizontal.3.decrease"), for: .bookmark, state: .normal)
        
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Coin"
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    
    
    // MARK: - UI Set UP
    
    private func setupUI() {
        self.navigationItem.title = "iCryptoPro"
        self.view.backgroundColor = UIColor(
            red: 21 / 255.0, green: 22 / 255.0, blue: 24 / 255.0, alpha: 1.0)
        
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

        ])
        
    }

}
// MARK: - Search Controller Functions

extension HomeController: UISearchResultsUpdating,UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
        self.viewModel.updateSearchController(searchBarText: searchController.searchBar.text)
    }
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("Bookmark button clicked")
    }
}

extension HomeController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let inSearchMode = self.viewModel.inSearchMode(searchController)
        return inSearchMode ? self.viewModel.filteredCoins.count :
        self.viewModel.allCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell",for: indexPath) as? CoinCell else {
            fatalError("Unable to dequeue CoinCell in HomeController")
        }
        let inSearchMode = self.viewModel.inSearchMode(searchController)
        let coin = inSearchMode ? self.viewModel.filteredCoins[indexPath.row] : self.viewModel.allCoins[indexPath.row]
        
        cell.configure(with: coin)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let inSearchMode = self.viewModel.inSearchMode(searchController)
        let coin = inSearchMode ? self.viewModel.filteredCoins[indexPath.row] : self.viewModel.allCoins[indexPath.row]
        
//        let coin = viewModel.allCoins[indexPath.row]
        let vm = ViewCryptoControllerViewModel(coin)
        let destinationVC = ViewCryptoController(vm)
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}
