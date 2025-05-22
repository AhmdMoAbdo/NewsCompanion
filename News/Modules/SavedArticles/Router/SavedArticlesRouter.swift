//
//  SavedArticlesRouter.swift
//  News
//
//  Created by Ahmed Abdo on 19/05/2025.
//

import UIKit

class SavedArticlesRouter: ListToDetailsRoutable {
    // MARK: - Properties
    private weak var viewController: SavedArticlesViewController?
    
    // MARK: - Module Creation
    static func createModule() -> UIViewController {
        let router = SavedArticlesRouter()
        let viewModel = SavedArticlesViewModel(router: router)
        let viewController = SavedArticlesViewController(viewModel: viewModel)
        router.viewController = viewController
        return viewController
    }
    
    // MARK: - Navigation
    func navigateToDetails(article: Article) {
        let detailsVC = DetailsRouter.createModule(article: article)
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
