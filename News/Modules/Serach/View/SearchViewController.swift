//
//  SearchViewController.swift
//  News
//
//  Created by Ahmed on 31/07/2023.
//

import UIKit
import Lottie

class SearchViewController: UIViewController {
    // MARK: - Outlet(s)
    @IBOutlet weak var searchTable: UITableView!
    
    // MARK: - Properties
    let emptyStateView = EmptyStateView()
    let viewModel: SearchViewModel
    let networkIndicator = UIActivityIndicatorView(style: .large)
    let preMadeAlerts = PreMadeAlerts()
    
    // MARK: - Initializer(s)
    init(viewModel: SearchViewModel) {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addGradientBackground()
        searchTable.reloadData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        setupArticlesTableView()
        setupActivityIndicator()
        emptyStateView.attach(to: view, using: "look", isHidden: false)
    }
    
    // MARK: - Table view setup
    private func setupArticlesTableView() {
        setupTableCellNib()
        addTableDelegates()
    }
    
    /// Table cell XIB
    private func setupTableCellNib() {
        searchTable.register(
            UINib(
                nibName: Constants.ArticleCell.cellClass,
                bundle: nil
            ),
            forCellReuseIdentifier: Constants.ArticleCell.cellName
        )
    }
    
    /// Table Data Source and delegates
    private func addTableDelegates() {
        searchTable.delegate = self
        searchTable.dataSource = self
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
    
    // MARK: - View Model Observable
    private func bindToViewModelObservables() {
        bindToLoadingObservable()
        bindToDataUpdateObservable()
        bindToConnectionStateObservable()
    }
    
    /// Loading observable
    private func bindToLoadingObservable() {
        viewModel.loadingObservable.observe { [weak self] isLoading in
            guard let self else { return }
            isLoading ? networkIndicator.startAnimating() : networkIndicator.stopAnimating()
            emptyStateView.isHidden = isLoading
            searchTable.isHidden = isLoading
        }
    }
    
    /// Data update observable
    private func bindToDataUpdateObservable() {
        viewModel.articlesListUpdateObservable.observe { [weak self] _ in
            guard let self else { return }
            searchTable.reloadData()
            if viewModel.articles.isEmpty {
                emptyStateView.isHidden = false
                emptyStateView.setup(imageName: Constants.Images.nothingFound)
                searchTable.isHidden = true
            } else {
                emptyStateView.isHidden = true
                searchTable.isHidden = false
            }
        }
    }
    
    /// Connection state observable
    private func bindToConnectionStateObservable() {
        viewModel.networkLostObservable.observe { [weak self] in
            guard let self else { return }
            present(
                preMadeAlerts.getOkStyleSheetAlert(
                    message: Constants.Alerts.searchError,
                    action: { [weak self] in
                        guard let self else { return }
                        navigationController?.popViewController(animated: true)
                    }
                ),
                animated: true
            )
        }
    }

    // MARK: - Typing in textField
    @IBAction func typingSearchQuery(_ sender: UITextField) {
        viewModel.searchQuery = sender.text ?? ""
    }
    
    // MARK: - Search Button Action
    @IBAction func searchButtonClicked(_ sender: Any) {
        if ReachabilityManager.shared.isConnected {
            networkIndicator.startAnimating()
            viewModel.getArticlesFromNetwork()
        } else {
            self.present(
                preMadeAlerts.getOkStyleSheetAlert(
                    message: Constants.Alerts.searchError
                ),
                animated: true
            )
        }
    }
    
    // MARK: - Back Button
    @IBAction func backButtonPressed(_ sender: UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Table view delegates
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.ArticleCell.cellName
        ) as? ArticleTableViewCell
        else { return UITableViewCell() }
        let isFav = viewModel.checkIfArticleIsSaved(article: viewModel.articles[indexPath.row])
        cell.setupCell(
            article: viewModel.articles[indexPath.row],
            isFavorite: isFav
        ) { [weak self] in
            guard let self else { return }
            handleFavButtonClick(articleIndex: indexPath.row, isFav: isFav)
        }
        return cell
    }
    
    /// Cell fav button action handling
    func handleFavButtonClick(articleIndex: Int, isFav: Bool) {
        guard let cell = searchTable.cellForRow(at: IndexPath(row: articleIndex, section: 0)) as? ArticleTableViewCell else { return }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.navigateToDetails(index: indexPath.row)
    }
}
