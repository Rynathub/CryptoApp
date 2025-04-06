//
//  SecondCustomSheetVC.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 29.03.2025.
//

import UIKit

class CustomSheetVC: UIViewController {

    var viewModel: ViewCryptoControllerViewModel
    
    
    private lazy var actionSheetStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
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
        view.backgroundColor = UIColor(
            red: 21 / 255.0, green: 22 / 255.0, blue: 24 / 255.0, alpha: 1.0)
        setUI()
        addButtons()
    }
    
    private func addButtons() {
        
        let actions = [
            (title:"  View on website",image:UIImage(systemName: "arrow.up.forward.app"),action:#selector(handleViewOnWebSite)),
            (title:"  Token details",image:UIImage(systemName: "chart.bar.horizontal.page.fill"),action:#selector(handleTokenDetails)),
        ]
        actions.forEach { actionItem in
            let button = UIButton(type: .system)
            button.setTitle(actionItem.title, for: .normal)
            button.setImage(actionItem.image, for: .normal)
            button.contentHorizontalAlignment = .left
            button.addTarget(self, action: actionItem.action, for: .touchUpInside)
            
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            button.tintColor = .label
           
           actionSheetStackView.addArrangedSubview(button)
            
            
        }
    }
    
    private func setUI() {
        self.view.addSubview(containerView)
        self.containerView.addSubview(actionSheetStackView)
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 7),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -7),
            containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -20),
            
            actionSheetStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            actionSheetStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            actionSheetStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            actionSheetStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
            
        ])
    }

    @objc private func handleTokenDetails() {
        // Capture the main window's root view controller before dismissing
        let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate
        let window = sceneDelegate?.window
        let rootVC = window?.rootViewController
        
        print("Root VC: \(String(describing: rootVC))")
        
        
        let destinationVC = TokenDetailsVC(viewModel: self.viewModel)
        
        
        destinationVC.modalPresentationStyle = .custom
        
        // Dismiss the sheet first
        dismiss(animated: true) { [weak self] in
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,let window = windowScene.windows.first,let rootViewController = window.rootViewController {
                rootViewController.present(destinationVC,animated: true)
                print("Presented TokenDetailsVC modally")
            }
        }
    }
    
    @objc private func handleViewOnWebSite() {
        if let url = URL(string:(self.viewModel.webSiteLink)!) {
            UIApplication.shared.open(url,options: [:],completionHandler: nil)
        }
        dismissActionSheet()
    }
    
    @objc  func dismissActionSheet() {
        dismiss(animated: true, completion: nil)
      }
}
