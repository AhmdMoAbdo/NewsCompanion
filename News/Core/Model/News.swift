//
//  News.swift
//  News
//
//  Created by Ahmed on 30/07/2023.
//

import Foundation

struct News: Codable {
    var status: String?
    var totalResults: Int?
    var articles: [Article]?
}
