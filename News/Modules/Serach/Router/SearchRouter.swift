//
//  SearchRouter.swift
//  News
//
//  Created by Ahmed Abdo on 19/05/2025.
//

import UIKit

class SearchRouter: ListToDetailsRoutable {
    // MARK: - Properties
    private weak var viewController: SearchViewController?
    
    // MARK: - Module Creation
    static func createModule() -> UIViewController {
        let router = SearchRouter()
        let viewModel = SearchViewModel(router: router)
        let viewController = SearchViewController(viewModel: viewModel)
        router.viewController = viewController
        return viewController
    }
    
    // MARK: - Navigation
    func navigateToDetails(article: Article) {
        let detailsVC = DetailsRouter.createModule(article: article)
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
