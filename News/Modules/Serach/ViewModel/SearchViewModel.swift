//
//  SearchViewModel.swift
//  News
//
//  Created by Ahmed on 31/07/2023.
//

import Foundation

class SearchViewModel: BaseViewModel {
    // MARK: - Parent Properties
    override func getEndPoint() -> EndPoint? {
        SearchEndPoints.search(query: searchQuery)
    }
    
    override var cacheReturenedArticles: Bool {
        return false
    }
    
    // MARK: - Local Properties
    var searchQuery: String = ""
    var networkLostObservable = Observable<Void>()
    
    // MARK: - Handle network state update
    override func didUpdateNetworkState(_ isConnected: Bool) {
        if articles.isEmpty && !isConnected {
            networkLostObservable.onNext(())
        }
    }
}
