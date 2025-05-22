//
//  DBManager.swift
//  News
//
//  Created by Ahmed on 01/08/2023.
//

import Foundation
import SwiftData

class DBManager {
    // MARK: - Singleton Instance
    static let shared = DBManager()
    
    // MARK: - DB Properteis
    let container: ModelContainer
    let modelContext: ModelContext
    
    // MARK: - Private init
    private init() {
        do {
            container = try ModelContainer(for: Article.self)
            modelContext = ModelContext(container)
        } catch {
            fatalError("Couldn't initialize SwiftData")
        }
    }
        
    // MARK: - Cache all Articles of a specific type
    func cacheArticles(articles: [Article], type: String) {
        deleteAllArticles(type: type)
        for article in articles {
            insertArticle(article, type: type)
        }
        try? modelContext.save()
    }
    
    /// Inserting a specific article if it was never in the DB or update the type set to contain its type
    func insertArticle(_ article: Article, type: String) {
        let foundArticles = fetchArticles(#Predicate { $0.title == article.title} )
        if foundArticles.isEmpty {
            article.type.append(type)
            modelContext.insert(article)
        } else {
            foundArticles.forEach {
                if $0.type.contains(type) { return }
                $0.type.append(type)
                modelContext.insert($0)
            }
        }
        try? modelContext.save()
    }
    
    // MARK: - Delete all articles of a specific type that are not in my favorites list
    func deleteAllArticles(type: String) {
        let cachedArticles = fetchArticles(type)
        for article in cachedArticles {
            if article.type.count == 1 {
                modelContext.delete(article)
            } else {
                article.type.removeAll { $0 == type }
                modelContext.insert(article)
            }
        }
        try? modelContext.save()
    }
    
    // MARK: - Get All cached articles
    func getCachedArticles(type: String) -> [Article] {
        fetchArticles(type)
    }
    
    // MARK: - Fetch articles based on a specific predicate
    func fetchArticles(_ predicate: Predicate<Article>) -> [Article] {
        return (try? modelContext.fetch(FetchDescriptor<Article>(predicate: predicate))) ?? []
    }
    
    func fetchArticles(_ type: String) -> [Article] {
        let foundItems = (try? modelContext.fetch(FetchDescriptor<Article>(predicate: #Predicate {
            $0.title != nil } ))) ?? []
        return foundItems.filter { $0.type.contains(type) }
    }
    
    
    // MARK: - Fav articles handling
    /// Getting Fav List
    func fetchFavoriteArticles() -> [Article] {
        return fetchArticles("favorite")
    }
    
    /// Check whether a specific article is in favorites list
    func checkIfArticleIsFav(article: Article) -> Bool {
        let articles = fetchArticles(#Predicate { $0.title == article.title })
        var found = false
        articles.forEach {
            if $0.type.contains("favorite") {
                found = true
                return
            }
        }
        return found
    }
    
    /// Add article to favorite
    func addArticleToFavDB(article: Article) {
        let foundArticles = fetchArticles(#Predicate { $0.title == article.title} )
        if foundArticles.isEmpty {
            article.type.append("favorite")
            modelContext.insert(article)
        } else {
            foundArticles.forEach {
                if !$0.type.contains("favorite") {
                    $0.type.append("favorite")
                    modelContext.insert($0)
                }
            }
        }
        try? modelContext.save()
    }
    
    /// Delete a specific article from favories list
    func deleteSpecificArticleFromFavorite(_ article: Article) {
        let foundArticles = fetchArticles(#Predicate { $0.title == article.title })
        foundArticles.forEach {
            $0.type.removeAll { $0.contains("favorite") }
            if $0.type.isEmpty {
                modelContext.delete($0)
            } else {
                modelContext.insert($0)
            }
        }
        try? modelContext.save()
    }
}
