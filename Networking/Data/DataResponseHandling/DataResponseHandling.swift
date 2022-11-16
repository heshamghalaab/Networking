//
//  DataResponseHandling.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import Foundation

protocol DataResponseHandling {
    func map<E>(_ output: URLSession.DataTaskPublisher.Output, for endPoint: E) throws -> Data where E: EndPoint
    init()
}
