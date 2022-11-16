//
//  RequestEndPoint.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import Foundation

struct RequestEndPoint<Response: Decodable, Parameter: Encodable>: EndPoint {
    
    typealias JSONResponseStructure = Response
    typealias ParameterStructure = Parameter
    
    var server: Server
    var absolutePath: AbsolutePath
    var parameters: Parameter?
    var httpMethod: HTTPMethod
    var headersComponents: HeaderComponent
    var requestTimeOut: Float

    var fullPath: String{
        server.baseURL + absolutePath.value
    }
    
    init(server: Server,
         absolutePath: AbsolutePath,
         parameters: Parameter? = nil,
         httpMethod: HTTPMethod = .get,
         headersComponents: HeaderComponent = .init(components: []),
         requestTimeOut: Float = 30) {
        
        self.server = server
        self.absolutePath = absolutePath
        self.parameters = parameters
        self.httpMethod = httpMethod
        self.headersComponents = headersComponents
        self.requestTimeOut = requestTimeOut
    }
}

struct EmptyParameter: Encodable { }
