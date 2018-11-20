//
//  ExtansionNumberFormatter.swift
//  GitTest
//
//  Created by Evgeniy on 10/30/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import Foundation

let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.groupingSeparator = ","
    formatter.numberStyle = .decimal
    return formatter
}()
