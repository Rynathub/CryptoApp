//
//  ViewController.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 20.02.2025.
//

import UIKit

class HomeController: UIViewController {

    private let viewModel: HomeControllerViewModel
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemBackground
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
        self.setupUI()
        
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        viewModel.coinsUpdated = { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        viewModel.onErrorMessage = { [weak self] error in
                // Show an alert or log the error
                print("Error: \(error)")
            }
        
        
    }

    
    private func setupUI() {
        self.navigationItem.title = "iCryptoPro"
        self.view.backgroundColor = .systemBackground
        
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

extension HomeController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell",for: indexPath) as? CoinCell else {
            fatalError("Unable to dequeue CoinCell in HomeController")
        }
        let coin = viewModel.coins[indexPath.row]
        cell.configure(with: coin)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let coin = viewModel.coins[indexPath.row]
        let vm = ViewCryptoControllerViewModel(coin)
        let destinationVC = ViewCryptoController(vm)
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}
