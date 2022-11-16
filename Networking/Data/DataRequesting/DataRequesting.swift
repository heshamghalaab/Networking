//
//  DataRequesting.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import Foundation
import Combine

protocol DataRequesting{
    func requestDataPublisher<E>(from endPoint: E) -> AnyPublisher<Data, NetworkError> where E : EndPoint
}
