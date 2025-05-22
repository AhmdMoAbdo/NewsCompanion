//
//  TabbarItems.swift
//  News
//
//  Created by Ahmed Abdo on 14/05/2025.
//

import UIKit

// MARK: - Tabbar Items
enum TabbarItems {
    case Home
    case Categories
    case Saved
    
    func getRelativeVC() -> UIViewController {
        switch self {
        case .Home:
            return HomeRouter.createModule()
            
        case .Categories:
            return CategoriesRouter.createModule()
            
        case .Saved:
            return SavedArticlesRouter.createModule()
        }
    }
    
    func getRelativeTitle() -> String {
        switch self {
        case .Home:
            return Constants.Tabbar.homeTitle
            
        case .Categories:
            return Constants.Tabbar.categroiesTitle
            
        case .Saved:
            return Constants.Tabbar.savedTitle
        }
    }
    
    func getRelativeImage(isSelected: Bool) -> UIImage? {
        var imageName = ""
        switch self {
        case .Home:
            imageName = Constants.Tabbar.homeImage
            
        case .Categories:
            imageName = Constants.Tabbar.categroiesImage
            
        case .Saved:
            imageName = Constants.Tabbar.savedImage
        }
        
        return UIImage(systemName: imageName)?.withTintColor(isSelected ? .black : .gray)
    }
}
