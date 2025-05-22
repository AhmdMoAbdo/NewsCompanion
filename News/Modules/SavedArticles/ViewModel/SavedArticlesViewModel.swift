//
//  SavedArticlesViewModel.swift
//  News
//
//  Created by Ahmed on 31/07/2023.
//

import Foundation

class SavedArticlesViewModel: SavedArticlesHandlable {
    var savedArticles: [Article] = []
    let router: SavedArticlesRouter
    
    // MARK: - Initializer
    init(router: SavedArticlesRouter) {
        self.router = router
        savedArticles = DBManager.shared.fetchFavoriteArticles()
    }
    
    // MARK: - Getting all saved articles
    func getSavedArticles() {
        savedArticles = DBManager.shared.fetchFavoriteArticles()
    }
    
    // MARK: - Navigate to details
    func navigateToArticleDetails(index: Int) {
        router.navigateToDetails(article: savedArticles[index])
    }
}
