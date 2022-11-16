//
//  URLRequestBuilding.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import Foundation

protocol URLRequestBuilding {
    func urlRequest<E>(from endPoint: E) -> URLRequest? where E : EndPoint
    init()
}
