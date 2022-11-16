//
//  URLSessionRequesting.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import Foundation

protocol URLSessionRequesting {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
    var delegate: URLSessionDelegate? { get }
}

extension URLSession: URLSessionRequesting {
}
