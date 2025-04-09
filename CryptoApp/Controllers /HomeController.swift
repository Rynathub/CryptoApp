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
        tv.backgroundColor = UIColor.appBackground
        tv.register(CoinCell.self, forCellReuseIdentifier: CoinCell.identifier)
        return tv
    }()
    
     lazy var themeButton: UIButton = {
         let button = UIButton(type: .custom)
         let imageName = (ThemeManager.shared.currentTheme == .dark) ? "sun.max.circle" : "moon.circle"
             let baseImage = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
             button.setImage(baseImage, for: .normal)
             button.tintColor = (ThemeManager.shared.currentTheme == .dark) ? .systemYellow : .systemIndigo
             button.addTarget(self, action: #selector(themeButtonTapped), for: .touchUpInside)
        return button
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
        self.navigationController?.navigationBar.barTintColor = UIColor.appBackground
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
        
    }

    private func setupSearchController() {

        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Coin"
        self.searchController.searchBar.showsBookmarkButton = true
        self.searchController.searchBar.setImage(UIImage(systemName: "line.horizontal.3.decrease"), for: .bookmark, state: .normal)
        
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    
    
    // MARK: - UI Set UP
    
    private func setupUI() {
        setupThemeTapCallBack()
        self.navigationItem.title = "iCryptoPro"
        self.navigationController?.navigationBar.barTintColor = UIColor.appBackground
        let themeBarButton = UIBarButtonItem(customView: themeButton)
            navigationItem.rightBarButtonItem = themeBarButton
        self.view.backgroundColor = UIColor.appBackground
        
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


extension HomeController {
    
    func setupThemeTapCallBack() {
        ThemeManager.shared.onThemeChanged = { [weak self] in
            self?.updateThemeButtonImage()
        }
    }
    
    func updateThemeButtonImage() {
        // Determine the new image based on the current theme.
        let newImageName = (ThemeManager.shared.currentTheme == .dark) ? "sun.max.circle" : "moon.circle"
        guard let newImage = UIImage(systemName: newImageName) else { return }
        
        let tintedImage: UIImage
            if newImageName == "sun.max.circle" {
                tintedImage = newImage.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
            } else {
                tintedImage = newImage.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal)
            }

        UIView.transition(with: themeButton,
                          duration: 0.5,
                          options: .curveEaseInOut,
                          animations: {
                                self.themeButton.setImage(tintedImage, for: .normal)
                          },
                          completion: nil)
    }
    
    @objc func themeButtonTapped() {
        ThemeManager.shared.toggleTheme()
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
        
        let vm = ViewCryptoControllerViewModel(coin)
        let destinationVC = ViewCryptoController(vm)
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}
