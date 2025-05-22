//
//  ArticlesService.swift
//  News
//
//  Created by Ahmed Abdo on 18/05/2025.
//

import Foundation

protocol EndPointProvider: AnyObject {
    func getEndPoint() -> EndPoint?
}

class ArticlesService: APIServiceProtocol {
    weak var endPointPresenter: EndPointProvider?
    
    init(endPointPresenter: EndPointProvider?) {
        self.endPointPresenter = endPointPresenter
    }
    
    func getArticles(completion: @escaping ([Article]) -> Void) {
        guard let urlRequest = endPointPresenter?.getEndPoint()?.urlRequest else {
            completion([])
            return
        }
        sendRequest(to: urlRequest) { (response: News?) in
            completion(response?.articles ?? [])
        }
    }
}
