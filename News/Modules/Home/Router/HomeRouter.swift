//
//  HomeRouter.swift
//  News
//
//  Created by Ahmed Abdo on 19/05/2025.
//

import UIKit

protocol ListToDetailsRoutable {
    func navigateToDetails(article: Article)
}

class HomeRouter: ListToDetailsRoutable {
    // MARK: - Properties
    private weak var viewController: HomeViewController?
    
    // MARK: - Module Creation
    static func createModule() -> UIViewController {
        let router = HomeRouter()
        let viewModel = HomeViewModel(router: router)
        let viewController = HomeViewController(viewModel: viewModel)
        router.viewController = viewController
        return viewController
    }
    
    // MARK: - Navigation
    func navigateToDetails(article: Article) {
        let detailsVC = DetailsRouter.createModule(article: article)
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
