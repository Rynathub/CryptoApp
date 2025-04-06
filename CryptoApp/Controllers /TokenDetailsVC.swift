//
//  TokenDetailsVC.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 31.03.2025.
//

import Foundation
import UIKit

class TokenDetailsVC: UIViewController {
    
    private var viewModel: ViewCryptoControllerViewModel
    
    
    init(viewModel: ViewCryptoControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        self.tokenImage.sd_setImage(with: self.viewModel.coin.logoURL)
        self.tokenSymbol.text = self.viewModel.coin.symbol
        self.tokenDecimalValueLabel.text = "\(self.viewModel.tokenDecimal)"
        print("TokenDetailsVC loaded")
    }
    //MARK: - UI
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [vStack1,vStack2,vStack3,vStack4,vStack5,vStack6])
        stack.axis = .vertical
        stack.spacing = 34
        stack.alignment = .leading
        return stack
    }()
    
    private let tokenLabel: UILabel = {
        let label = UILabel()
        label.text = "Token"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let tokenImage: UIImageView = {
        let imageView = UIImageView()
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 36),
            imageView.widthAnchor.constraint(equalToConstant: 36)
        ])
        return imageView
    }()
    
    private let tokenSymbol: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private lazy var vStack1: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tokenLabel,tokenImageSymStack])
        stack.axis = .vertical
        stack.spacing = 6
        return stack
    }()
    
    private let tokenAmount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "Token Amount"
        return label
    }()
    
    private let tokenAmountValue: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "0 ($0.00)"
        return label
    }()
    
    private lazy var vStack2: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tokenAmount,tokenAmountValue])
        stack.axis = .vertical
        stack.spacing = 6
        return stack
    }()
    
    private lazy var tokenAdressLabel: UILabel = {
        let label = UILabel()
        label.text = "Token adress"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let clipBoardImage:UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "square.on.square")
        image?.withRenderingMode(.automatic)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 18),
            imageView.heightAnchor.constraint(equalToConstant: 18)
        ])
        return imageView
    }()
    
    private lazy var tokenAdressLabelValue: UILabel = {
        let label = UILabel()
        let shortened = self.viewModel.tokenAddress
        let attributes:[NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemBlue
        ]
        label.attributedText = NSAttributedString(string: shortened, attributes: attributes)
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addressLabelTapped))
        label.addGestureRecognizer(tapGesture)
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tokenAdressLabelValue,clipBoardImage])
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    
    private lazy var vStack3: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tokenAdressLabel,hStack])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private let tokenDecimalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "Token Decimal"
        return label
    }()
    
    private let tokenDecimalValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private lazy var vStack4:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tokenDecimalLabel,tokenDecimalValueLabel])
        stack.axis = .vertical
        stack.spacing = 6
        return stack
    }()
    
    private let netWorkLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "Network"
        return label
    }()
    
    private let netWorkValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "Ethereum Main Network"
        return label
    }()
    
    private lazy var vStack5:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [netWorkLabel,netWorkValueLabel])
        stack.axis = .vertical
        stack.spacing = 6
        return stack
    }()
    
    private let tokenListsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "Token Lists"
        return label
    }()
    
    private let tokenListsValue: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Metamask, Aave, Bancor, CoinGecko, 1inch, PMM, Zerion, Socket, Openswap"
        return label
    }()
    
    private lazy var vStack6:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tokenListsLabel,tokenListsValue])
        stack.axis = .vertical
        stack.spacing = 6
        return stack
    }()
    
    private lazy var tokenImageSymStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tokenImage,tokenSymbol])
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    private let labelTokenDetails:UILabel = {
       let label = UILabel()
        label.text = "Token Details"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let labelTokenNetWork:UILabel = {
        let label = UILabel()
        label.text = "Ethereum Main Network"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var mainBarStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [labelTokenDetails,labelTokenNetWork])
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .center
        return stack
    }()
    
    private let closeButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        return button
    }()
    
    func setUpUI() {
        self.view.backgroundColor = UIColor(
            red: 21 / 255.0, green: 22 / 255.0, blue: 24 / 255.0, alpha: 1.0)
        
        self.view.addSubview(mainBarStack)
        self.view.addSubview(closeButton)
        self.view.addSubview(mainStack)
        
        mainBarStack.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            
            mainBarStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            mainBarStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            
            mainStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 15),
            mainStack.topAnchor.constraint(equalTo: mainBarStack.bottomAnchor, constant: 25),
            mainStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
//            mainStack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
    
    @objc private func addressLabelTapped() {
        UIPasteboard.general.string = viewModel.coin.fullAddress
        print("Copied \(self.viewModel.coin.fullAddress) to clipboard!")
        
        let alert = UIAlertController(title: nil, message: "Copied to clipboard!", preferredStyle: .alert)
        present(alert,animated: true , completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    alert.dismiss(animated: true, completion: nil)
                }
    }
}
