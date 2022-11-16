//
//  Server.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import Foundation

/// Server uses a **Strategy Pattern** to select a specific types to its coressponding servers.
enum Server {
    case main

    var baseURL: String{
        switch self{
        case .main: return "https://api.coingecko.com/"
        }
    }

    /// It can take either a server url or full path
    init(path: String) {
        switch path{
        case let value where value.contains(Server.main.baseURL): self = .main
        default: fatalError("UnExpeced, please handle any new servers here")
        }
    }
}
