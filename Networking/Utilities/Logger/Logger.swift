//
//  Logger.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import Foundation

public func logInfo(_ message: String, tag: LogTag, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    #if !STORE
    Logger.shared.logMessage(.info, tag: tag, message: message, file: file, function: function, line: line)
    #endif
}

public func logWarning(_ message: String, tag: LogTag, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    #if !STORE
    Logger.shared.logMessage(.warning, tag: tag, message: message, file: file, function: function, line: line)
    #endif
}

public func logError(_ message: String, tag: LogTag, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    #if !STORE
    Logger.shared.logMessage(.error, tag: tag, message: message, file: file, function: function, line: line)
    #endif
}

public enum LogTag: String {
    case networking

    var emoji: String {
        switch self {
        case .networking: return "☁️"
        }
    }
}

public enum LogFlag {
    case info, warning, error
}

public protocol LoggerType {
    func start()
    func logMessage(_ flag: LogFlag, tag: LogTag, message: String, file: StaticString, function: StaticString, line: UInt)
}

public class Logger: LoggerType {

    public static let shared: LoggerType = Logger()

    private let loggers: [LoggerProviderType]

    init(loggers: [LoggerProviderType] = [LocalLogger()]) {
        self.loggers = loggers
    }

    public func start() {
        #if !STORE
        loggers.forEach { $0.setup() }
        #endif
    }

    public func logMessage(_ flag: LogFlag, tag: LogTag, message: String, file: StaticString, function: StaticString, line: UInt) {
        #if !STORE
        loggers.forEach {
            let fullMessage = "\(tag.emoji) \(message)"
            $0.logMessage(flag, tag: tag, message: fullMessage, file: file, function: function, line: line)
        }
        #endif
    }
}
