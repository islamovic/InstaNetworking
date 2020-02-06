//
//  RequestOperation.swift
//  InstaNetworking
//
//  Created by Islam on 2/6/20.
//  Copyright © 2020 App Lineup. All rights reserved.
//

import Foundation

final class RequestOperation: InstaOperation {

    private var task    : URLSessionTask?
    private let endPoint: InstaEndPoint?
    private let session : URLSession?
    private let baseURL : URL?
    private let success : NetworkRouterSuccessCompletion
    private let failure : NetworkRouterFailedCompletion

    init(task: URLSessionTask?,
         endPoint: InstaEndPoint?,
         session : URLSession?,
         baseURL : URL?,
         success : @escaping NetworkRouterSuccessCompletion,
         failure : @escaping NetworkRouterFailedCompletion) {

        self.task     = task
        self.endPoint = endPoint
        self.session  = session
        self.baseURL  = baseURL
        self.success  = success
        self.failure  = failure
    }

    override func main() {

        if let session = session, let endpoint = endPoint {
            do {
                let request = try self.buildRequest(from: endpoint)
                task = session.dataTask(with: request, completionHandler: { (data, response, error) in

                    if let error = error {
                        self.failure(error)
                    } else {
                        let statusCode = self.isSuccessCode(response)
                        if statusCode, let data = data, let response = response {
                            self.success(data, response)
                        } else {
                            self.failure(error!)
                        }
                    }
                    self.finish()
                })
            } catch {
                failure(error)
                finish()
            }
            self.task?.resume()
        }
    }
}

extension RequestOperation {

    fileprivate func buildRequest(from route: InstaEndPoint) throws -> URLRequest {

        var request = URLRequest(url: URL(fileURLWithPath: ""))
        if let path = route.path, let baseURL = baseURL {
            request = URLRequest(url: baseURL.appendingPathComponent(path))
        }
        request.httpMethod = route.method.rawValue

        do {
            switch route.method {
                case .get:
                    try self.configure(bodyParameters: nil, urlParameters: route.parameters, request: &request)
                case .post:
                    try self.configure(bodyParameters: route.parameters, urlParameters: nil, request: &request)
            }
            try additiona(headers: route.headers, request: &request)
        } catch {
            throw error
        }

        return request
    }

    fileprivate func configure(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {

        do {
            if let bodyParameters = bodyParameters {
                try JSONParametersEncoder.encode(request: &request, parameters: bodyParameters)
            }
            if let urlParameters = urlParameters {
                try URLParameteersEncoder.encode(request: &request, parameters: urlParameters)
            }
        } catch {
            throw error
        }
    }

    fileprivate func additiona(headers: HTTPHeaders?, request: inout URLRequest) throws {
        guard let headers = headers else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }

    private func isSuccessCode(_ statusCode: Int) -> Bool {
        return statusCode >= 200 && statusCode < 300
    }

    private func isSuccessCode(_ response: URLResponse?) -> Bool {
        guard let urlResponse = response as? HTTPURLResponse else {
            return false
        }
        return isSuccessCode(urlResponse.statusCode)
    }
}
