//
//  DataRequester.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import Foundation
import Combine

struct DataRequester: DataRequesting {
    
    private let urlSession: URLSessionRequesting
    
    init(urlSession: URLSessionRequesting = URLSession(
        configuration: .default,
        delegate: CertificatePinningDelegate(),
        delegateQueue: nil)
    ) {
        self.urlSession = urlSession
    }

    func requestDataPublisher<E>(from endPoint: E) -> AnyPublisher<Data, NetworkError> where E : EndPoint {
        if let delegate = urlSession.delegate as? CertificatePinningDelegate{
            delegate.willRequest(
                for: endPoint.server,
                absolutePath: endPoint.absolutePath,
                fullPath: endPoint.fullPath)
        }

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(endPoint.requestTimeOut)
        
        let urlRequestBuilder = endPoint.server.urlRequestBuilding.init()
        guard let request = urlRequestBuilder.urlRequest(from: endPoint) else {
            return AnyPublisher(
                Fail<Data, NetworkError>(error: NetworkError.invalidURLRequest)
            )
        }
        
        return urlSession
            .dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                let dataResponseHandler = endPoint.server.dataResponseHandling.init()
                return try dataResponseHandler.map(output, for: endPoint)
            }
            .mapError { error -> NetworkError in
                error as? NetworkError ?? .networkError(error)
            }
            .eraseToAnyPublisher()
    }
}
