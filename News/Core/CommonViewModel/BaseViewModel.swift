//
//  BaseViewModel.swift
//  News
//
//  Created by Ahmed on 01/08/2023.
//

import Foundation

class BaseViewModel: NetworkStateObservable, SavedArticlesHandlable, EndPointProvider {
    var listType: String { "" }
    var articlesListService: ArticlesService?
    var cacheReturenedArticles: Bool {
        true
    }
    var articles: [Article] = []
    var articlesListUpdateObservable = Observable<ListSource>()
    var loadingObservable = Observable<Bool>()
    let router: ListToDetailsRoutable
    
    // MARK: - Initializer(s)
    init(router: ListToDetailsRoutable) {
        self.router = router
        articlesListService = ArticlesService(endPointPresenter: self)
        ReachabilityManager.shared.observeNetworkState(observer: self)
    }
    
    // MARK: - Getting articles from 2 sources based on network connection availability
    func getArticles() {
        if ReachabilityManager.shared.isConnected {
            getArticlesFromNetwork()
        } else {
            getArticlesFromDB()
        }
    }
    
    /// Getting articles from network
    func getArticlesFromNetwork() {
        loadingObservable.onNext(true)
        articlesListService?.getArticles() { [weak self] returnedArticles in
            guard let self else { return }
            self.loadingObservable.onNext(false)
            articles = returnedArticles
            if cacheReturenedArticles {
                DBManager.shared.cacheArticles(articles: articles, type: listType)
            }
            articlesListUpdateObservable.onNext((.fromAPI))
        }
    }
    
    /// Getting articles from DB
    private func getArticlesFromDB() {
        articles = DBManager.shared.getCachedArticles(type: listType)
        articlesListUpdateObservable.onNext((.fromDB))
    }
    
    // MARK: - Favorite handling
    /// Check whether a specific article is in favorites list
    func checkIfArticleIsSaved(article: Article) -> Bool {
        return DBManager.shared.checkIfArticleIsFav(article: article)
    }
    
    // MARK: - Network Updates delegate to inidicate network state changes
    func didUpdateNetworkState(_ isConnected: Bool) {
        getArticles()
    }
    
    func getEndPoint() -> (any EndPoint)? {
        nil
    }
    
    // MARK: - Navigate to details
    func navigateToDetails(index: Int) {
        router.navigateToDetails(article: articles[index])
    }
}

protocol SavedArticlesHandlable {
    func addArticleToFav(article: Article)
    func deleteArticleFromFav(article: Article)
}

extension SavedArticlesHandlable {
    /// Add article to favorite
    func addArticleToFav(article: Article) {
        DBManager.shared.addArticleToFavDB(article: article)
    }
    
    /// Delete a specific article from favories list
    func deleteArticleFromFav(article: Article) {
        DBManager.shared.deleteSpecificArticleFromFavorite(article)
    }
}

// MARK: - List type
enum ListSource {
    case fromAPI
    case fromDB
}
