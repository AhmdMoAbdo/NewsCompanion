//
//  CategoriesRouter.swift
//  News
//
//  Created by Ahmed Abdo on 19/05/2025.
//

import UIKit

class CategoriesRouter: ListToDetailsRoutable {
    // MARK: - Properties
    private weak var viewController: CategoriesViewController?
    
    // MARK: - Module Creation
    static func createModule() -> UIViewController {
        let router = CategoriesRouter()
        let viewModel = CategoriesViewModel(router: router)
        let viewController = CategoriesViewController(viewModel: viewModel)
        router.viewController = viewController
        return viewController
    }
    
    // MARK: - Navigation
    func navigateToDetails(article: Article) {
        let detailsVC = DetailsRouter.createModule(article: article)
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
