//
//  HeaderComponent.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import Foundation

struct HeaderComponent {
    
    var headers = [String: String]()
    
    init(server: Server) {
        prepareHeaders(for: server)
    }
    
    init(components: [Component]) {
        prepareHeaders(with: components)
    }
    
    private mutating func prepareHeaders(with components: [Component]){
        for component in components{
            updateHeaders(with: component)
        }
    }

    private mutating func prepareHeaders(for server: Server){
        switch server {
        case .main:
            prepareHeaders(
                with: [
                    .contentType(.applicationJson),
                    .token("")
                ]
            )
        }
    }
    
    private mutating func updateHeaders(with component: Component){
        switch component {
        case .accept(let value): headers[component.key] = value.rawValue
        case .contentType(let value): headers[component.key] = value.rawValue
        case .token(let value): headers[component.key] = value
        case .appVersion:
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            headers[component.key] = version ?? String()
        }
    }
    
    enum Component {
        case accept(_ value: Accept)
        case contentType(_ value: ContentType)
        case token(_ value: String)
        case appVersion
        
        var key: String{
            switch self{
            case .accept:   return "Accept"
            case .contentType: return "Content-Type"
            case .token:    return "Token"
            case .appVersion: return "App-Version"
            }
        }
    }
    
    enum Accept: String{
        /// The Response expected to be in JSON format
        case applicationJson = "application/json"
    }
    
    enum ContentType: String{
        /// The request is JSON
        case applicationJson = "application/json"
    }
}
