//
//  ExtensionNSString.swift
//  GitTest
//
//  Created by Evgeniy on 10/31/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import Foundation

extension NSString {
    @objc func firstLetter() -> String {
        if self.length == 0 {
            return ""
        }
        return self.substring(to: 1).capitalized
    }
}
