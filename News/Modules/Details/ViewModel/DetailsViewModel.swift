//
//  DetailsViewModel.swift
//  News
//
//  Created by Ahmed on 31/07/2023.
//

import Foundation

class DetailsViewModel: SavedArticlesHandlable {
    // MARK: - Properties
    var article: Article
    let router: DetailsRouter
    
    // MARK: - Initializer(s)
    init(article: Article, router: DetailsRouter) {
        self.router = router
        self.article = article
        if DBManager.shared.checkIfArticleIsFav(article: article) {
            if article.type.contains(Constants.DB.favorite) { return }
            article.type.append(Constants.DB.favorite)
        }
    }
    
    // MARK: - Fav state handling
    /// Adding to fav
    func addArticleToFav() {
        addArticleToFav(article: article)
        if !article.type.contains(Constants.DB.favorite) {
            article.type.append(Constants.DB.favorite)
        }
    }
    
    /// Deleting from Fav
    func deleteArticleFromSaved() {
        deleteArticleFromFav(article: article)
        article.type.removeAll(where: { $0 == Constants.DB.favorite })
    }
    
    // MARK: - Present full article details
    func presentFullArticleDetails() {
        router.navigate(to: .fullArticleDetails(url: article.url ?? ""))
    }
}
