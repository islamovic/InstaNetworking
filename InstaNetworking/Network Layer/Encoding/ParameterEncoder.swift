//
//  ParameterEncoder.swift
//  InstaNetworking
//
//  Created by Islam on 2/6/20.
//  Copyright © 2020 App Lineup. All rights reserved.
//

import Foundation

public enum NetworkError: String, Error {
    case parametersNIL  = "parameters were nil."
    case encodingFailed = "parameters encoding failed."
    case missingURL     = "URL is nil."
}

protocol ParameterEncoder {
    static func encode(request: inout URLRequest, parameters: Parameters) throws
}
