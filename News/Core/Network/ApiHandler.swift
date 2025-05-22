//
//  ApiHandler.swift
//  News
//
//  Created by Ahmed on 30/07/2023.
//

import Foundation

protocol APIServiceProtocol {
    func sendRequest<U: Codable>(
        to urlRequest: URLRequest,
        completionHandler: @escaping (U?) -> Void
    )
}

extension APIServiceProtocol {
    func sendRequest<U: Codable>(
        to urlRequest: URLRequest,
        completionHandler: @escaping (U?) -> Void
    ) {
        URLSession.shared.dataTask(
            with: urlRequest
        ) { data, response, error in
            guard let data = data else {
                completionHandler(nil)
                return
            }
            let decodedData = try? JSONDecoder().decode(U.self, from: data)
            DispatchQueue.main.async {
                completionHandler(decodedData)
            }
        }.resume()
    }
}
