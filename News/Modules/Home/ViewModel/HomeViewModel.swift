//
//  HomeViewModel.swift
//  News
//
//  Created by Ahmed on 30/07/2023.
//

import Foundation

class HomeViewModel: BaseViewModel {
    // MARK: - Parent Functionalities
    override var listType: String {
        return Constants.DB.home
    }
    
    override func getEndPoint() -> EndPoint? {
        ArticlesEndpoint.articles(type: Constants.DB.home)
    }
}
