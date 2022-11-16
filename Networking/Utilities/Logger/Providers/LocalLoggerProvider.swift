//
//  LocalLoggerProvider.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import Foundation
import os.log

extension OSLog {
    private static let subSystem = Bundle.main.bundleIdentifier!
    static let networking = OSLog(subsystem: OSLog.subSystem, category: LogTag.networking.rawValue)
}

public class LocalLogger: LoggerProviderType {

    func setup() { /* No Setup Needed. */ }

    func logMessage(_ flag: LogFlag, tag: LogTag, message: String, file: StaticString, function: StaticString, line: UInt) {
        os_log("%@", log: tag.toOSLog, type: flag.toOSLogType, message)
    }
}

private extension LogTag {
    var toOSLog: OSLog {
        switch self {
        case .networking: return .networking
        }
    }
}

private extension LogFlag {
    var toOSLogType: OSLogType {
        switch self {
        case .info: return .info
        case .warning: return .debug
        case .error: return .error
        }
    }
}
