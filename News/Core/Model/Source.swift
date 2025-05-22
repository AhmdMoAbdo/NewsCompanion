//
//  Source.swift
//  News
//
//  Created by Ahmed on 30/07/2023.
//

import Foundation
import SwiftData

@Model
final class Source {
    // MARK: - Properties
    @Attribute(.unique) var id: String?
    var name: String?
    
    // MARK: - Initializer(s)
    init(id: String? = nil, name: String? = nil) {
        self.id = id
        self.name = name
    }
}

// MARK: - Encoding + Decoding
extension Source: Codable {
    /// Coding Keys
    enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
    }
}
