//
//  DataResponseHandler.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import Foundation

struct DataResponseHandler: DataResponseHandling {

    struct ErrorResponse: Decodable {
        var error: String
        let code: Int?
    }

    struct ValidationErrorResponse: Decodable {
        var reason: String
    }

    func map<E>(_ output: URLSession.DataTaskPublisher.Output, for endPoint: E) throws -> Data where E : EndPoint {
        prettyPrintedLog(for: output, in: endPoint)
        guard let response = output.response as? HTTPURLResponse else {
            throw NetworkError.invalidURLResponse
        }
        guard (200...299).contains(response.statusCode) else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: output.data) {
                throw NetworkError.errorResponse(code: errorResponse.code ?? -1, error: errorResponse.error)
            }

            switch response.statusCode {
            case 400:
                let apiError = try? JSONDecoder().decode(ValidationErrorResponse.self, from: output.data)
                throw NetworkError.validationError(reason: apiError?.reason ?? "unKnown Validation Error.")
            case 401:
                throw NetworkError.sessionExpired
            case 408:
                throw NetworkError.timeOut
            default:
                throw NetworkError.apiError(code: response.statusCode)
            }
        }
        return output.data
    }

    private func prettyPrintedLog<E>(for output: URLSession.DataTaskPublisher.Output, in endPoint: E) where E : EndPoint {
        guard let response = output.response as? HTTPURLResponse else {
            logInfo("Error In Response \(E.self)", tag: .networking)
            return
        }
        let emojie = (200...299).contains(response.statusCode) == true ? "✅" : "❌"
        logInfo(
            """
            Response Status Code: \(emojie) \(response.statusCode)
            ⬇️ For: \(endPoint.httpMethod.rawValue.uppercased()) '\(endPoint.fullPath)'
            ⬇️ Response headers: \(response.allHeaderFields.prettyPrinted)
            ⬇️ Response: \(output.data.prettyPrinted)
            """,
            tag: .networking)
    }
}

