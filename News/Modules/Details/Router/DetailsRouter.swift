//
//  DetailsRouter.swift
//  News
//
//  Created by Ahmed Abdo on 19/05/2025.
//

import UIKit

class DetailsRouter {
    // MARK: - Routes
    enum route {
        case fullArticleDetails(url: String)
    }
    
    // MARK: - Proeprties
    private weak var viewController: DetailsViewController?
    
    // MARK: - Module Creation
    static func createModule(article: Article) -> UIViewController {
        let router = DetailsRouter()
        let viewModel = DetailsViewModel(article: article, router: router)
        let viewController = DetailsViewController(viewModel: viewModel)
        router.viewController = viewController
        return viewController
    }
    
    // MARK: - Navigation
    func navigate(to route: route) {
        switch route {
        case let .fullArticleDetails(url):
            presentFullArticleDeatils(url: url)
        }
    }
    
    // MARK: - Full article deatils view
    private func presentFullArticleDeatils(url: String) {
        let webViewController = WebViewController(url: url)
        viewController?.present(webViewController, animated: true)
    }
}
