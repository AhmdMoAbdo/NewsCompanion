//
//  HomeViewController.swift
//  News
//
//  Created by Ahmed on 30/07/2023.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Outlet(s)
    @IBOutlet weak var screenHeader: TabbarScreenHeader!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var homeArticlesTable: UITableView!
    
    // MARK: - Properties
    let emptyStateView = EmptyStateView()
    var viewModel: HomeViewModel
    let preMadeAlerts = PreMadeAlerts()
    var refreshControl: UIRefreshControl?
    let networkIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Initializer(s)
    init(viewModel: HomeViewModel) {
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
        homeArticlesTable.reloadData()
    }
    
    // MARK: - Initial UI Setup
    func setupUI() {
        setupScreenHeader()
        setupArticlesTableView()
        setupActivityIndicator()
        emptyStateView.attach(to: view, using: Constants.Images.nothingFound)
    }
    
    // MARK: - Header Setup
    private func setupScreenHeader() {
        screenHeader.setupHeader(
            configurations: TabbarHeaderViewConfigurations(
                title: Constants.Tabbar.homeTitle,
                animationName: Constants.LottieAnimation.home,
                animationToTextSpacing: 0
            ),
            containerVC: self
        )
    }
    
    // MARK: - Table view setup
    private func setupArticlesTableView() {
        setupTableCellNib()
        addTableDelegates()
        refreshControl = homeArticlesTable.addSwipeToRefresh { [weak self] in
            guard let self else { return }
            viewModel.getArticles()
        }
    }
    
    /// Table cell XIB
    private func setupTableCellNib() {
        homeArticlesTable.register(
            UINib(
                nibName: Constants.ArticleCell.cellClass,
                bundle: nil
            ),
            forCellReuseIdentifier: Constants.ArticleCell.cellName
        )
    }
    
    /// Table Data Source and delegates
    private func addTableDelegates() {
        homeArticlesTable.delegate = self
        homeArticlesTable.dataSource = self
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
    
    // MARK: - Loading
    private func bindToLoadingObservable() {
        viewModel.loadingObservable.observe { [weak self] isLoading in
            guard let self else { return }
            dateLabel.isHidden = isLoading
            refreshButton.isHidden = isLoading
            if isLoading {
                networkIndicator.startAnimating()
            } else {
                refreshControl?.endRefreshing()
                networkIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - Data observable
    private func bindToDataUpdateObservable() {
        viewModel.articlesListUpdateObservable.observe { [weak self] _ in
            guard let self else { return }
            prepareDate()
            screenHeader.playLottieAnimation()
            if viewModel.articles.isEmpty {
                emptyStateView.isHidden = false
                homeArticlesTable.isHidden = true
            } else {
                emptyStateView.isHidden = true
                homeArticlesTable.isHidden = false
            }
            homeArticlesTable.reloadData()
        }
    }
    
    /// Preparing Date after the last reload
    func prepareDate() {
        dateLabel.isHidden = false
        if ReachabilityManager.shared.isConnected {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "h:mm a 'on' EEEE- MMMM dd, yyyy"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            let dateString = formatter.string(from: Date())
            dateLabel.text = "\(Constants.Home.lastUpdatedText)\n\(dateString)"
            dateLabel.textColor = .black
        } else {
            dateLabel.text = "\(Constants.Home.lastUpdatedText)\n\(Constants.Home.offline)"
            dateLabel.textColor = .red
        }
    }
    
    // MARK: - Refresh Button action
    @IBAction func refreshButtonCLicked(_ sender: Any) {
        viewModel.getArticles()
    }
}

// MARK: - Table View Handling
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
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
        guard let cell = homeArticlesTable.cellForRow(at: IndexPath(row: articleIndex, section: 0)) as? ArticleTableViewCell else { return }
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
