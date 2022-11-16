//
//  PrettyPrintedLog+Extension.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import Foundation

extension Data {
    var prettyPrinted: String {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: .mutableLeaves)
            let prettyPrintedData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return String(data: prettyPrintedData, encoding: .utf8) ?? "EMPTY"
        } catch {
            return "Not a valid Data"
        }
    }
}

extension Dictionary {
    var prettyPrinted: String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? "Not a valid JSON"
        } catch {
            return "Not a valid JSON"
        }
    }
}
