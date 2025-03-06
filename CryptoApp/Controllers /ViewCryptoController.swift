//
//  ViewCryptoController.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 21.02.2025.
//

import UIKit

class ViewCryptoController: UIViewController {
    
   
    let viewModel: ViewCryptoControllerViewModel
    
    private let scrollView: UIScrollView = {
       let sv = UIScrollView()
         return sv
    }()
    
    private let contentView: UIView = {
        let v = UIView()
         return v
    }()
    
    private let coinLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "questionmark")
        imageView.tintColor = .label
         return imageView
    }()
    
    private let rankLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "Error"
        return label
    }()
    
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "Error"
        return label
    }()
    
    private let marketCapLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "Error"
        return label
    }()
    
    private let maxSupplyLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 500
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [rankLabel,priceLabel,marketCapLabel,maxSupplyLabel])
        vStack.axis = .vertical
        vStack.spacing = 12
        vStack.distribution = .fill
        vStack.alignment = .center
        return vStack
    }()
    
    
    init(_ viewModel: ViewCryptoControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        navigationItem.title = viewModel.coin.name
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: nil, action: nil)
        
//        self.rankLabel.text = coin.cmc_rank.description
        self.rankLabel.text = viewModel.coin.rank?.description

//        self.priceLabel.text = coin.quote.USD.price.description
        self.priceLabel.text = viewModel.coin.pricingData.USD.price.description

//        self.marketCapLabel.text = coin.quote.USD.market_cap.description
        self.marketCapLabel.text = viewModel.coin.pricingData.USD.market_cap.description

        self.maxSupplyLabel.text = viewModel.coin.maxSupply?.description ??
        "123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123123\n123"
        
        
        setupUI()
        self.viewModel.onImageLoaded = { [weak self] logoImage in
            DispatchQueue.main.async {
                self?.coinLogo.image = logoImage
            }
            
        }
        
    }
    

   
    private func setupUI() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        self.contentView.addSubview(coinLogo)
        self.contentView.addSubview(vStack)
//        self.contentView.addSubview(rankLabel)
//        self.contentView.addSubview(priceLabel)
//        self.contentView.addSubview(marketCapLabel)
//        self.contentView.addSubview(maxSupplyLabel)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        coinLogo.translatesAutoresizingMaskIntoConstraints = false
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        let height = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        height.priority = UILayoutPriority(1)
        height.isActive = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
           
            
            coinLogo.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            coinLogo.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            coinLogo.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            coinLogo.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            coinLogo.heightAnchor.constraint(equalToConstant: 200),

            
            
            vStack.topAnchor.constraint(equalTo: coinLogo.bottomAnchor,constant: 20),
            vStack.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            vStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)

        ])

    }
}
