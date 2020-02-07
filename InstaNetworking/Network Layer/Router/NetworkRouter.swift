//
//  NetworkRouter.swift
//  InstaNetworking
//
//  Created by Islam on 2/6/20.
//  Copyright © 2020 App Lineup. All rights reserved.
//

import Foundation

public typealias NetworkRouterSuccessCompletion = (_ data: Data, _ response: URLResponse) -> ()
public typealias NetworkRouterFailedCompletion = (_ error: Error) -> ()

protocol NetworkRouter {
    associatedtype EndPoint: InstaEndPoint
    func request(_ route: EndPoint, success: @escaping NetworkRouterSuccessCompletion, failure: @escaping NetworkRouterFailedCompletion)
    func cancel()
}
