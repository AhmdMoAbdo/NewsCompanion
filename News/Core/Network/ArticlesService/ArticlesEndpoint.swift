//
//  ArticlesEndpoint.swift
//  News
//
//  Created by Ahmed Abdo on 21/05/2025.
//

import Foundation

enum ArticlesEndpoint: EndPoint {
    case articles(type: String)
}

extension ArticlesEndpoint {
    var path: String {
        "top-headlines"
    }
    
    var queryParameters: [String : String?] {
        switch self {
        case let .articles(type):
            ["category" : type]
        }
    }
    
    var headers: [String : String] {
        [:]
    }
    
    var bodyParmaters: [String : Any?] {
        [:]
    }
}
