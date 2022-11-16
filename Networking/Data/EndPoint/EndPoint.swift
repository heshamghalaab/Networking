//
//  EndPoint.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import Foundation

protocol EndPoint {
    associatedtype JSONResponseStructure: Decodable
    associatedtype ParameterStructure: Encodable
    
    var server: Server { get }
    var absolutePath: AbsolutePath { get }
    var parameters: ParameterStructure? { get }
    var httpMethod: HTTPMethod { get }
    var headersComponents: HeaderComponent { get }
    var requestTimeOut: Float { get }
    var fullPath: String { get }
}
