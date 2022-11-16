//
//  NetworkError.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import Foundation

public enum NetworkError: Error {
    case invalidURLRequest
    case invalidURLResponse
    case networkError(Error)
    case validationError(reason: String)
    case sessionExpired
    case apiError(code: Int)
    case decodingError(_ error: String)
    case errorResponse(code: Int, error: String)
    case timeOut
}

extension NetworkError: Equatable{
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURLRequest, .invalidURLRequest):
            return true
        case (.invalidURLResponse, .invalidURLResponse):
            return true
        case (.networkError(let lValue), .networkError(let rValue)):
            return lValue.localizedDescription == rValue.localizedDescription
        case (.validationError(let lValue), .validationError(let rValue)):
            return lValue == rValue
        case (.sessionExpired, .sessionExpired):
            return true
        case (.apiError(let lValue), .apiError(let rValue)):
            return lValue == rValue
        case (.decodingError(let lValue), .decodingError(let rValue)):
            return lValue == rValue
        case (.errorResponse(let lCode, let lValue), .errorResponse(let rCode, let rValue)):
            return lCode == rCode && lValue == rValue
        case (.timeOut, .timeOut):
            return true
        default: return false
        }
    }
}
