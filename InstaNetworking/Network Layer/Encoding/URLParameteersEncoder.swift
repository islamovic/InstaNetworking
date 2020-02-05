//
//  URLParameteersEncoder.swift
//  InstaNetworking
//
//  Created by Islam on 2/6/20.
//  Copyright © 2020 App Lineup. All rights reserved.
//

import Foundation

class URLParameteersEncoder: ParameterEncoder {

    static func encode(request: inout URLRequest, parameters: Parameters) throws {

        guard let url = request.url else { throw NetworkError.missingURL }

        if var components = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {

            components.queryItems = [URLQueryItem]()

            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                components.queryItems?.append(queryItem)
            }
            request.url = components.url
        }

        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}

