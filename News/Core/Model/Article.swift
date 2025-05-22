//
//  Article.swift
//  News
//
//  Created by Ahmed on 30/07/2023.
//

import Foundation
import SwiftData

@Model
final class Article {
    // MARK: - Properties
    var source: Source?
    var author: String?
    @Attribute(.unique) var title: String?
    var articleDescription: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    var type = [String]()
    
    // MARK: - Initializer(s)
    init(
        source: Source? = nil,
        author: String? = nil,
        title: String? = nil,
        articleDescription: String? = nil,
        url: String? = nil,
        urlToImage: String? = nil,
        publishedAt: String? = nil,
        content: String? = nil,
        type: [String] = []
    ) {
        self.source = source
        self.author = author
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
        self.type = type
    }
}

// MARK: - Encoding + Decoding
extension Article: Codable {
    /// Coding Keys
    enum CodingKeys: String, CodingKey {
        case articleDescription = "description"
        case source, author, title, url, urlToImage, publishedAt, content
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        source = try container.decodeIfPresent(Source.self, forKey: .source)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        articleDescription = try container.decodeIfPresent(String.self, forKey: .articleDescription)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        publishedAt = try container.decodeIfPresent(String.self, forKey: .publishedAt)
        content = try container.decodeIfPresent(String.self, forKey: .content)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(author, forKey: .author)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(articleDescription, forKey: .articleDescription)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(urlToImage, forKey: .urlToImage)
        try container.encodeIfPresent(publishedAt, forKey: .publishedAt)
        try container.encodeIfPresent(content, forKey: .content)
    }
}
