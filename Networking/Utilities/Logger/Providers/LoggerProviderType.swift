//
//  LoggerProviderType.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import Foundation

protocol LoggerProviderType {
    func logMessage(_ flag: LogFlag, tag: LogTag, message: String, file: StaticString, function: StaticString, line: UInt)
    func setup()
}
