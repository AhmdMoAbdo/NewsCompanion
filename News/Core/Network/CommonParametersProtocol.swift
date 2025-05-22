//
//  CommonParametersProtocol.swift
//  News
//
//  Created by Ahmed Abdo on 21/05/2025.
//

import Foundation

public protocol CommonParametersProtocol {
    var commonParameters: [String: String] { get }
}

public extension CommonParametersProtocol {
    var commonParameters: [String: String] {
        var params = [String: String]()
        params["language"] = "en"
        params["apiKey"] = ""
        return params
    }
}
