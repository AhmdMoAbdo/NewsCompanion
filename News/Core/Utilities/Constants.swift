//
//  Constants.swift
//  News
//
//  Created by Ahmed Abdo on 21/05/2025.
//

import Foundation

enum Constants {
    // MARK: - Images
    enum Images {
        static let bookMark = "bookmark"
        static let bookMarkFilled = "bookmark.fill"
        static let imageNotAvailable = "notAvailable"
        static let nothingFound = "nothing"
    }
    
    // MARK: - Lottie animations
    enum LottieAnimation {
        static let home = "home"
        static let category = "category"
    }
    
    // MARK: - Alerts
    enum Alerts {
        static let searchError = "Connect to the Internet to enable search functionality"
        static let connectToReadArticle = "Connect to the Internet to read the full article"
        static let deleteMessage = "Are you sure you want to delete this article from your saved list?"
        static let webLoadingError = "Couldn't load web page"
        static let warning = "Warning"
        static let addedMessage = "Added to saved list"
        static let deleteAction = "Delete"
        static let cancelAction = "Cancel"
        static let okAction = "ok"
    }
    
    // MARK: - Article Cell
    enum ArticleCell {
        static let cellName = "articleCell"
        static let cellClass = "ArticleTableViewCell"
    }
    
    // MARK: - Tabbar
    enum Tabbar {
        static let homeTitle = "Home"
        static let homeImage = "house"
        static let categroiesTitle = "Categories"
        static let categroiesImage = "rectangle.and.text.magnifyingglass.rtl"
        static let savedTitle = "Saved"
        static let savedImage = "bookmark"
    }
    
    // MARK: - Categories
    enum Categories {
        static let offlineText = "Offline Mode\nShowing previously retrieved data"
    }
    
    // MARK: - Home
    enum Home {
        static let lastUpdatedText = "Last updated:"
        static let offline = "offline"
    }
    
    // MARK: - Database
    enum DB {
        static let favorite = "favorite"
        static let home = "general"
    }
}
