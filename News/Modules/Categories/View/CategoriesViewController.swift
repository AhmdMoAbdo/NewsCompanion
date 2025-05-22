//
//  CategoriesViewController.swift
//  News
//
//  Created by Ahmed on 31/07/2023.
//

import UIKit

class CategoriesViewController: UIViewController {
    // MARK: - Outlet(s)
    @IBOutlet weak var screenHeader: TabbarScreenHeader!
    @IBOutlet weak var noConnectionLabel: UILabel!
    @IBOutlet weak var categorizedArticlesTable: UITableView!
    @IBOutlet weak var techButton: UIButton!
    @IBOutlet weak var healthButton: UIButton!
    @IBOutlet weak var sportsButton: UIButton!
    @IBOutlet weak var businessButton: UIButton!
    @IBOutlet weak var scienceButton: UIButton!
    
    // MARK: - Properties
    let emptyStateView = EmptyStateView()
    let preMadeAlerts = PreMadeAlerts()
    var refreshControl: UIRefreshControl?
    var viewModel: CategoriesViewModel
    var categoryButtonsArray: [UIButton] {
        [techButton, healthButton, sportsButton, businessButton, scienceButton]
    }
    let networkIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Initializer(s)
    init(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindToViewModelObservables()
        viewModel.getArticles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addGradientBackground()
        categorizedArticlesTable.reloadData()
    }
    
    // MARK: - Initial UI Setup
    func setupUI() {
        setupScreenHeader()
        setupArticlesTableView()
        prepareButtonArray()
        setupActivityIndicator()
        emptyStateView.attach(to: view, using: Constants.Images.nothingFound)
    }
    
    // MARK: - Header Setup
    private func setupScreenHeader() {
        screenHeader.setupHeader(
            configurations: TabbarHeaderViewConfigurations(
                title: Constants.Tabbar.categroiesTitle,
                animationName: Constants.LottieAnimation.category,
                allowSegmentedAnimation: true
            ),
            containerVC: self
        )
    }
    
    // MARK: - Table view setup
    private func setupArticlesTableView() {
        setupTableCellNib()
        addTableDelegates()
        refreshControl = categorizedArticlesTable.addSwipeToRefresh { [weak self] in
            guard let self else { return }
            viewModel.getArticles()
        }
    }
    
    /// Table cell XIB
    private func setupTableCellNib() {
        categorizedArticlesTable.register(
            UINib(
                nibName: Constants.ArticleCell.cellClass,
                bundle: nil
            ),
            forCellReuseIdentifier: Constants.ArticleCell.cellName
        )
    }
    
    /// Table Data Source and delegates
    private func addTableDelegates() {
        categorizedArticlesTable.delegate = self
        categorizedArticlesTable.dataSource = self
    }
    
    // MARK: - Preapare buttons array appearance
    func prepareButtonArray() {
        updateButtonsArrayBasedOnSelection(selectedIndex: 0)
        categoryButtonsArray.forEach { $0.layer.cornerRadius = 25 }
        for categoryButton in categoryButtonsArray {
            categoryButton.layer.cornerRadius = 25
        }
    }
    
    func updateButtonsArrayBasedOnSelection(selectedIndex: Int) {
        categoryButtonsArray.forEach { $0.backgroundColor = .lightGray }
        categoryButtonsArray[selectedIndex].backgroundColor = .orange
    }
    
    // MARK: - Setting up activity indicator
    func setupActivityIndicator() {
        view.addSubview(networkIndicator)
        networkIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            networkIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            networkIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    // MARK: - ViewModel Observable(s)
    private func bindToViewModelObservables() {
        bindToLoadingObservable()
        bindToDataUpdateObservable()
    }
    
    // MARK: - Loading Obsrevable
    private func bindToLoadingObservable() {
        viewModel.loadingObservable.observe { [weak self] isLoading in
            guard let self else { return }
            emptyStateView.isHidden = isLoading
            categorizedArticlesTable.isHidden = isLoading
            if isLoading {
                networkIndicator.startAnimating()
            } else {
                refreshControl?.endRefreshing()
                networkIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - Data update observable
    private func bindToDataUpdateObservable() {
        viewModel.articlesListUpdateObservable.observe { [weak self] _ in
            guard let self else { return }
            handleOfflineText()
            screenHeader.playLottieAnimation()
            if viewModel.articles.isEmpty {
                emptyStateView.isHidden = false
                categorizedArticlesTable.isHidden = true
            } else {
                emptyStateView.isHidden = true
                categorizedArticlesTable.isHidden = false
            }
            categorizedArticlesTable.reloadData()
            if !viewModel.articles.isEmpty {
                categorizedArticlesTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    // MARK: - Offline indicator text
    func handleOfflineText() {
        if ReachabilityManager.shared.isConnected {
            noConnectionLabel.text = ""
        }else{
            noConnectionLabel.text = "Offline Mode\nShowing previously retrieved data"
        }
    }
        
    // MARK: - Selecting a category
    @IBAction func categorySelected(_ sender: UIButton) {
        let selectedButtonIndex = categoryButtonsArray.firstIndex(where: { $0 == sender }) ?? 0
        updateButtonsArrayBasedOnSelection(selectedIndex: selectedButtonIndex)
        viewModel.didSelectCategory(at: selectedButtonIndex)
    }
}

// MARK: - Table View Handling
extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    
    // MARK: - Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.ArticleCell.cellName
        ) as? ArticleTableViewCell else { return UITableViewCell() }
        let isFav = viewModel.checkIfArticleIsSaved(article: viewModel.articles[indexPath.row])
        cell.setupCell(
            article: viewModel.articles[indexPath.row],
            isFavorite: isFav
        ) { [weak self] in
            guard let self else { return }
            self.handleFavButtonClick(articleIndex: indexPath.row, isFav: isFav)
        }
        return cell
    }
    
    /// Cell fav button action handling
    func handleFavButtonClick(articleIndex: Int, isFav: Bool) {
        guard let cell = categorizedArticlesTable.cellForRow(at: IndexPath(row: articleIndex, section: 0)) as? ArticleTableViewCell else { return }
        if viewModel.checkIfArticleIsSaved(article: viewModel.articles[articleIndex]) {
            self.present(preMadeAlerts.getDeleteConfirmationAlert { [weak self] in
                guard let self else { return }
                cell.updateFavButtonImage(isFavorite: false)
                viewModel.deleteArticleFromFav(article: (viewModel.articles[articleIndex]))
            }, animated: true)
        } else {
            cell.updateFavButtonImage(isFavorite: true)
            viewModel.addArticleToFav(article: viewModel.articles[articleIndex])
            self.present(preMadeAlerts.getOkStyleSheetAlert(), animated: true)
        }
    }
    
    // MARK: - Cell selection action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.navigateToDetails(index: indexPath.row)
    }
    
    /// Adding spacing underneath the last table to avoid overlapping with the tabbar
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
}
