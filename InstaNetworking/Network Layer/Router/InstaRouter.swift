//
//  InstaRouter.swift
//  InstaNetworking
//
//  Created by Islam on 2/6/20.
//  Copyright © 2020 App Lineup. All rights reserved.
//

import Foundation
import Network

public class InstaRouter: NetworkRouter {

    private var task: URLSessionTask?
    private var session: URLSession?
    private var queue = OperationQueue()

    let wifiMonitor = NWPathMonitor(requiredInterfaceType: .wifi)
    let wifiQueue = DispatchQueue(label: "InternetWIFIConnectionMonitor")

    let celluarMonitor = NWPathMonitor(requiredInterfaceType: .cellular)
    let celluarQueue = DispatchQueue(label: "InternetCELLUARConnectionMonitor")

    public var baseURL: URL?

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

        wifiMonitor.pathUpdateHandler = { pathUpdateHandler in
            if pathUpdateHandler.status == .satisfied {
                self.queue.maxConcurrentOperationCount = 6
            }
        }
        wifiMonitor.start(queue: wifiQueue)

        celluarMonitor.pathUpdateHandler = { pathUpdateHandler in
            if pathUpdateHandler.status == .satisfied {
                self.queue.maxConcurrentOperationCount = 2
            }
        }
        celluarMonitor.start(queue: celluarQueue)
    }

    public static let shared = InstaRouter()

    public func request(_ route: InstaEndPoint,
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

    public func cancel() {
        self.task?.cancel()
    }
}
