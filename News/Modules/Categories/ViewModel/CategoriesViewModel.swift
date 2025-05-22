//
//  CategoriesViewModel.swift
//  News
//
//  Created by Ahmed on 31/07/2023.
//

import Foundation

class CategoriesViewModel: BaseViewModel {
    // MARK: - Parent Functionalities
    override func getEndPoint() -> EndPoint? {
        ArticlesEndpoint.articles(type: selectedCategory.rawValue)
    }
    
    override var listType: String {
        selectedCategory.rawValue
    }
    
    // MARK: - Local Properties
    var categoriesArr = ArticlesCategories.allCases
    var selectedCategory: ArticlesCategories = .tech
    
    // MARK: - Selecting a specific category
    func didSelectCategory(at index: Int) {
        selectedCategory = categoriesArr[index]
        getArticles()
    }
}

// MARK: - Categories
enum ArticlesCategories: String, CaseIterable {
    case tech = "technology"
    case health = "health"
    case sport = "sports"
    case business = "business"
    case science = "science"
}
