//
//  AbsolutePath.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import Foundation

enum AbsolutePath {
    case coins(Coins)
    
    var value: String{
        switch self {
        case .coins(let path): return path.value
        }
    }
}

enum Coins {
    case markets

    var value: String {
        switch self {
            case .markets: return "api/v3/coins/markets"
        }
    }
}
