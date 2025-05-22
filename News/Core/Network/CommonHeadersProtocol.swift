//
//  CommonHeadersProtocol.swift
//  News
//
//  Created by Ahmed Abdo on 18/05/2025.
//

import Foundation

public protocol CommonHeadersProtocol {
    var commonHeaders: [String: String] { get }
}

public extension CommonHeadersProtocol {
    var commonHeaders: [String: String] {
        var params = [String: String]()
        params["Content-Type"] = "application/json"
        params["Accept"] = "application/json"
        return params
    }
}
