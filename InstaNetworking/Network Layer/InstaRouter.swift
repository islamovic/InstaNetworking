//
//  InstaRouter.swift
//  InstaNetworking
//
//  Created by Islam on 2/6/20.
//  Copyright © 2020 App Lineup. All rights reserved.
//

import Foundation

class InstaRouter: NetworkRouter {

    private var task: URLSessionTask?
    private var session: URLSession?
    private var queue = OperationQueue()

    var baseURL: URL?

    private init() {
        let configuration = URLSessionConfiguration.default

        configuration.allowsCellularAccess      = true
        configuration.httpCookieAcceptPolicy    = .onlyFromMainDocumentDomain
        configuration.requestCachePolicy        = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 10.0

        session = URLSession(configuration: configuration)

        queue.maxConcurrentOperationCount = 6
        queue.qualityOfService = .default
        queue.waitUntilAllOperationsAreFinished()
    }

    public static let shared = InstaRouter()

    func request(_ route: InstaEndPoint,
                 success: @escaping NetworkRouterSuccessCompletion,
                 failure: @escaping NetworkRouterFailedCompletion) {

        let requestOperation = RequestOperation(task: task,
                                                endPoint: route,
                                                session: session,
                                                baseURL: baseURL,
                                                success: success,
                                                failure: failure)
        queue.addOperation(requestOperation)
    }

    func cancel() {
        self.task?.cancel()
    }
}
