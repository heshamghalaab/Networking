//
//  String+Extension.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import Foundation
import UIKit

extension String {
    var isValidURL: Bool {
        guard let url = URL(string: self) else { return false }
        
        var canOpenURL: Bool = false
        if Thread.isMainThread {
            canOpenURL = UIApplication.shared.canOpenURL(url)
        } else {
            DispatchQueue.main.async {
                canOpenURL = UIApplication.shared.canOpenURL(url)
            }
        }
        return canOpenURL
    }
}
