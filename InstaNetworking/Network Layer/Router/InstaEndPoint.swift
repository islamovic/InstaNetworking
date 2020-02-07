//
//  InstaEndPoint.swift
//  InstaNetworking
//
//  Created by Islam on 2/6/20.
//  Copyright © 2020 App Lineup. All rights reserved.
//

import Foundation

public typealias Parameters  = [String: Any]
public typealias HTTPHeaders = [String: String]

public enum HTTPMethod: String {
    case get  = "GET"
    case post = "POST"
}

public class InstaEndPoint {

    var path      : String?
    var headers   : HTTPHeaders?
    var method    : HTTPMethod
    var parameters: Parameters?

    public init(path: String? = nil,
          parameters: Parameters? = nil,
             headers: HTTPHeaders? = nil,
              method: HTTPMethod) {

        self.path       = path
        self.headers    = headers
        self.method     = method
        self.parameters = parameters
    }
}
