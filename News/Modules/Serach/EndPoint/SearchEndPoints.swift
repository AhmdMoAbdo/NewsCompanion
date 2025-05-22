//
//  SearchEndPoints.swift
//  News
//
//  Created by Ahmed Abdo on 18/05/2025.
//

import Foundation

enum SearchEndPoints: EndPoint {
    case search(query: String)
}

extension SearchEndPoints {
    var path: String {
        return "everything"
    }
    
    var queryParameters: [String : String?] {
        switch self {
        case let .search(query):
            return ["q": query]
        }
    }
    
    var bodyParmaters: [String : Any?] {
        return [:]
    }
    
    var headers: [String : String] {
        return [:]
    }
}
