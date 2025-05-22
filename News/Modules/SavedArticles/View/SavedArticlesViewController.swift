//
//  SavedArticlesViewController.swift
//  News
//
//  Created by Ahmed on 31/07/2023.
//

import UIKit

class SavedArticlesViewController: UIViewController {
    // MARK: - Outlet(s)
    @IBOutlet weak var screenHeader: TabbarScreenHeader!
    @IBOutlet weak var savedArticlesTable: UITableView!
    
    // MARK: - Properties
    var viewModel: SavedArticlesViewModel
    let preMadeAlerts = PreMadeAlerts()
    let emptyStateView = EmptyStateView()
    
    // MARK: - Initializer(s)
    init(viewModel: SavedArticlesViewModel) {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        screenHeader.playLottieAnimation()
        addGradientBackground()
        getSavedArticles()
    }
    
    // MARK: - Initial UI Setup
    func setupUI() {
        setupScreenHeader()
        setupArticlesTableView()
        emptyStateView.attach(to: view, using: "nothing")
    }
    
    // MARK: - Header Setup
    private func setupScreenHeader() {
        screenHeader.setupHeader(
            configurations: TabbarHeaderViewConfigurations(
                title: "Saved",
                animationName: "bookmark"
            ),
            containerVC: self
        )
    }
    
    // MARK: - Table view setup
    private func setupArticlesTableView() {
        setupTableCellNib()
        addTableDelegates()
    }
    
    /// Table cell XIB
    private func setupTableCellNib() {
        savedArticlesTable.register(
            UINib(
                nibName: Constants.ArticleCell.cellClass,
                bundle: nil
            ),
            forCellReuseIdentifier: Constants.ArticleCell.cellName
        )
    }
    
    /// Table Data Source and delegates
    private func addTableDelegates() {
        savedArticlesTable.delegate = self
        savedArticlesTable.dataSource = self
    }
    
    func getSavedArticles() {
        viewModel.getSavedArticles()
        if viewModel.savedArticles.isEmpty {
            emptyStateView.isHidden = false
            savedArticlesTable.isHidden = true
        } else {
            emptyStateView.isHidden = true
            savedArticlesTable.isHidden = false
            savedArticlesTable.reloadData()
        }
    }
}

// MARK: - Table handling
extension SavedArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.savedArticles.count
    }
    
    // MARK: - Cell setup
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.ArticleCell.cellName
        ) as? ArticleTableViewCell
        else { return UITableViewCell() }
        cell.setupCell(
            article: viewModel.savedArticles[indexPath.row],
            isFavorite: true
        ) { [weak self] in
            guard let self else { return }
            self.deleteArticle(articleIndex: indexPath)
        }
        return cell
    }
    
    /// Delete cell from fav
    func deleteArticle(articleIndex: IndexPath) {
        self.present(
            preMadeAlerts.getDeleteConfirmationAlert { [weak self] in
                guard let self else { return }
                viewModel.deleteArticleFromFav(article: viewModel.savedArticles[articleIndex.row])
                getSavedArticles()
            },
            animated: true
        )
    }
    
    // MARK: - Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.navigateToArticleDetails(index: indexPath.row)
    }
    
    // MARK: - Swipe to delete action
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        deleteArticle(articleIndex: indexPath)
    }
    
    /// Adding spacing underneath the last table to avoid overlapping with the tabbar
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
}
