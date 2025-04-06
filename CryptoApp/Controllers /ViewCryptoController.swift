//
//  ViewCryptoController.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 21.02.2025.
//

import DGCharts
import UIKit

class ViewCryptoController: UIViewController, ChartViewDelegate {

    let viewModel: ViewCryptoControllerViewModel
    
    let customSheet: CustomSheetVC
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()

    private lazy var contentView: UIView = {
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

    private let navImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let navLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .semibold)
        lbl.textColor = .label
        return lbl
    }()

    private lazy var navStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [navImageView, navLabel])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .center
        return stack
    }()
    // MARK: - User's Balance
    private let yourBalanceLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .label
        lb.font = .systemFont(ofSize: 24, weight: .semibold)
        lb.text = "Your balance"
        return lb
    }()
    
    private let coinImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "questionmark")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 32),
            imageView.heightAnchor.constraint(equalToConstant: 32)
        ])
        return imageView
    }()
    
    private let coinName: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        label.text = "$0.00"
        return label
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var balanceAndSymStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [balanceLabel,symbolLabel])
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.spacing = 6
        return stack
    }()
    
    private lazy var imageAndNameStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [coinImage,coinName])
        stack.axis = .horizontal
        stack.spacing = 12
        coinName.setContentHuggingPriority(.defaultLow, for: .horizontal)
        coinName.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return stack
    }()
    
    private lazy var parentBalanceStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageAndNameStack, balanceAndSymStack])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    //To make it breaks line by word
    private lazy var usersBalanceStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [yourBalanceLabel, parentBalanceStack])
        stack.axis = .vertical
        stack.spacing = 15
        stack.distribution = .fillProportionally 
        
        return stack
    }()
    // MARK: - Price Info

    private let nameSymLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .lightGray
        lb.font = .systemFont(ofSize: 16, weight: .regular)
        return lb
    }()
    
    private let timeConstrainLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .lightGray
        lb.font = .systemFont(ofSize: 16, weight: .semibold)
        lb.text = "Today"
        return lb
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.text = "Error"
        return label
    }()
    
    private let percentChangeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    private let changedPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        return label
    }()
    
    private let priceChangeImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var priceStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameSymLabel, priceLabel,priceChangeStack])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var priceChangeStack: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [priceChangeImage,changedPriceLabel,percentChangeLabel,timeConstrainLabel])
        hStack.axis = .horizontal
        hStack.spacing = 2
        return hStack
    }()
    // MARK: - Transaction history
    
    private let activityLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = .systemFont(ofSize: 24, weight: .semibold)
        lb.textAlignment = .left
        lb.text = "Bitcoin activity"
        return lb
    }()
    
    private let noTransactionLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .lightGray
        lb.font = .systemFont(ofSize: 20, weight: .medium)
        lb.textAlignment = .center
        lb.text = "You have no transactions!"
        return lb
    }()
    
    private lazy var activityStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [activityLabel,noTransactionLabel])
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    // MARK: - General Info

    private let marketCapLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "Market Cap"
        return label
    }()

    private let maxSupplyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "Max Supply"
        return label
    }()
    
    private let volumeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "Total Volume (24h)"
        return label
    }()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "Rank"
        return label
    }()
    
    private let rankValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let volumeValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let maxSupplyValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let marketCapValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let marketDetailsLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .label
        lb.font = .systemFont(ofSize: 25, weight: .semibold)
        lb.text = "Market details"
        return lb
    }()
    
    private lazy var vStackValues: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [rankValue,marketCapValue,volumeValue,maxSupplyValue])
        stack.spacing = 12
        stack.axis = .vertical
        stack.alignment = .trailing
        return stack
    }()

    private lazy var vStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [
            rankLabel, marketCapLabel,volumeLabel,maxSupplyLabel
        ])
        vStack.axis = .vertical
        vStack.spacing = 12
        vStack.alignment = .leading
        return vStack
    }()
    
    private lazy var detailLabelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .leading
        return stack
    }()

    private lazy var lineChartView: LineChartView = {
        let lineChartView = LineChartView()
        return lineChartView
    }()

    // MARK: - LifeCycle

    init(_ viewModel: ViewCryptoControllerViewModel) {
        self.viewModel = viewModel
        self.customSheet = CustomSheetVC(viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = UIColor(
            red: 21 / 255.0, green: 22 / 255.0, blue: 24 / 255.0, alpha: 1.0)

        configureNavigationBar()
        
        lineChartView.delegate = self

        self.priceLabel.text = viewModel.priceLabel
        
        self.nameSymLabel.text = viewModel.nameSymLabel
        
        self.changedPriceLabel.text = viewModel.changedPriceLabel
        
        self.percentChangeLabel.text = viewModel.percentChangeLabel
        
        self.coinName.text = viewModel.coin.name
        
        self.symbolLabel.text = viewModel.nameSymLabel2

        setupUI()
        
        setupChartAppearance()
        
        self.percentChangeLabelSetUp()

        self.coinLogo.sd_setImage(with: self.viewModel.coin.logoURL)
        
        self.coinImage.sd_setImage(with: self.viewModel.coin.logoURL)

        viewModel.onChartDataReady = { [weak self] in
            DispatchQueue.main.async {
                self?.loadChartData()
            }
        }
        
        self.rankValue.text = self.viewModel.rankLabel
        self.marketCapValue.text = self.viewModel.marketCapLabel
        self.volumeValue.text = self.viewModel.volumeLabel
        self.maxSupplyValue.text = self.viewModel.maxSupplyLabel


    }
    
    // MARK: - Chart set up

    func percentChangeLabelSetUp() {
        
        if viewModel.isPresentPositiveChange == true {
            let image = UIImage(systemName: "arrow.up.right")
            self.priceChangeImage.image = image?.withRenderingMode(.automatic)
            self.priceChangeImage.tintColor = .systemGreen
            self.changedPriceLabel.textColor = .systemGreen
            self.percentChangeLabel.textColor = .systemGreen
        } else {
            let image = UIImage(systemName: "arrow.down.right")
            self.priceChangeImage.image = image?.withRenderingMode(.automatic)
            self.priceChangeImage.tintColor = .systemRed
            self.changedPriceLabel.textColor = .systemRed
            self.percentChangeLabel.textColor = .systemRed
        }
    }

    // MARK: - Navigation Bar set up

    private func configureNavigationBar() {
        
        
        navigationItem.titleView = navStack

        navImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navImageView.widthAnchor.constraint(equalToConstant: 24),
            navImageView.heightAnchor.constraint(equalToConstant: 23),

        ])

        navImageView.sd_setImage(with: viewModel.coin.logoURL)
        navLabel.text = viewModel.coin.name

        self.navigationController?.navigationBar.topItem?.backBarButtonItem =
            UIBarButtonItem(
                title: "Back", style: .done, target: nil, action: nil)
        
        let threeDotsButton = UIBarButtonItem(
                    image: UIImage(systemName: "ellipsis.circle"),
                    style: .plain,
                    target: self,
                    action: #selector(showActionSheet)
                )
        self.navigationItem.rightBarButtonItem = threeDotsButton
        
    }
    @objc private func showActionSheet() {
//        let vc = CustomSheetVC()
        let navVC = UINavigationController(rootViewController: customSheet)
        
        
        if let sheet = navVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                0.15 * context.maximumDetentValue
            })]
            sheet.prefersGrabberVisible = true
        }
    
        navigationController?.present(navVC, animated: true)
    }
    
    // MARK: - Main UI

    private func setupUI() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        self.contentView.addSubview(priceStack)
//        self.contentView.addSubview(priceLabel)
        //        self.contentView.addSubview(coinLogo)
        self.contentView.addSubview(lineChartView)
        self.contentView.addSubview(usersBalanceStack)
        self.contentView.addSubview(marketDetailsLabel)
        self.contentView.addSubview(vStack)
        self.contentView.addSubview(vStackValues)
        self.contentView.addSubview(activityStack)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        priceStack.translatesAutoresizingMaskIntoConstraints = false
//        priceLabel.translatesAutoresizingMaskIntoConstraints = false
//        coinLogo.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        usersBalanceStack.translatesAutoresizingMaskIntoConstraints = false
        marketDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStackValues.translatesAutoresizingMaskIntoConstraints = false
        activityStack.translatesAutoresizingMaskIntoConstraints = false
        
        let height = contentView.heightAnchor.constraint(
            equalTo: scrollView.heightAnchor)
        height.priority = UILayoutPriority(1)
        height.isActive = true

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(
                equalTo: view.layoutMarginsGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(
                equalTo: view.layoutMarginsGuide.heightAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            priceStack.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 15),
            priceStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            priceStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            priceStack.bottomAnchor.constraint(equalTo: lineChartView.topAnchor,constant: -10),

            lineChartView.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor),
            lineChartView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor),
            lineChartView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            lineChartView.heightAnchor.constraint(equalToConstant: 300),
           
            usersBalanceStack.topAnchor.constraint(equalTo: lineChartView.bottomAnchor,constant: 25),
            usersBalanceStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),
            usersBalanceStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            usersBalanceStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            
            
            marketDetailsLabel.topAnchor.constraint(equalTo: usersBalanceStack.bottomAnchor, constant: 30),
            marketDetailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),
            marketDetailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            vStack.topAnchor.constraint(
                equalTo: self.marketDetailsLabel.bottomAnchor, constant: 20),
            vStack.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor, constant: 15),
            vStack.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor),
            vStack.bottomAnchor.constraint(
                equalTo: self.activityStack.topAnchor,constant: -50),
            
            vStackValues.topAnchor.constraint(equalTo: self.marketDetailsLabel.bottomAnchor,constant: 20),
            vStackValues.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -15),
            vStackValues.bottomAnchor.constraint(equalTo:self.activityStack.topAnchor,constant: -50),
            
            activityStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            activityStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            noTransactionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

        ])
        marketDetailsLabel.topAnchor.constraint(
            equalTo: usersBalanceStack.bottomAnchor,
            constant: 30
        ).priority = .init(750)

    }
}
// MARK: - Chart set up
private let circleMarker = CircleMarker()


extension ViewCryptoController {
     func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {

    }
    private func setupChartAppearance() {
        
        lineChartView.chartDescription.enabled = false
        lineChartView.legend.enabled = false

        // 2. Disable grid lines and axis lines
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false

        // 3. Hide axis labels
        lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        // 4. Remove borders / axis lines
        lineChartView.xAxis.drawAxisLineEnabled = true
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        
        // Removes default padding around the edges
        lineChartView.setViewPortOffsets(left: 0, top: 0, right: 0, bottom: 0)

        // 5. Disable zoom/pan if desired
        lineChartView.setScaleEnabled(false)
        lineChartView.pinchZoomEnabled = false
        lineChartView.dragEnabled = false

        // 6. Optional: Remove touch highlights
        lineChartView.highlightPerTapEnabled = true
        lineChartView.highlightPerDragEnabled = true
        
        lineChartView.drawMarkers = true
        circleMarker.chartView = lineChartView
        lineChartView.marker = circleMarker


        // 7. Optional: Adjust chart offsets if you want the line to fill the view
//        lineChartView.setViewPortOffsets(left: 0, top: 0, right: 0, bottom: 0)
        lineChartView.noDataText = "Loading chart data..."
        lineChartView.noDataTextColor = .lightGray
        // 8. Set background color to match your design
        // (If you have a dark background, set it here)
        lineChartView.backgroundColor = UIColor(
            red: 21 / 255.0, green: 22 / 255.0, blue: 24 / 255.0, alpha: 1.0)
    }

    private func loadChartData() {
        let dataSet = LineChartDataSet(
            entries: viewModel.dataEntries, label: "")
        
        dataSet.colors = [.systemBlue]  // Line color
        dataSet.lineWidth = 2.0  // Line thickness
        dataSet.drawValuesEnabled = false  // Hide value labels on points
        dataSet.drawCirclesEnabled = false  // Hide circles on each data point
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.highlightLineWidth = 2.0
        dataSet.lineWidth = 3.0
        dataSet.mode = .cubicBezier
        dataSet.highlightColor = .systemBlue
        // Optionally fill the area under the line (solid color or gradient)
        dataSet.drawFilledEnabled = true
        dataSet.fillColor = .systemBlue.withAlphaComponent(0.5)  // Slightly transparent
        // Create chart data object

        // Set data for the chart
        let lineData = LineChartData(dataSet: dataSet)
        lineChartView.data = lineData
    }
    
}
