//
//  RequestParameters.swift
//  GitTest
//
//  Created by Evgeniy on 10/30/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import Foundation

struct RequestParameters {
    struct Servers {
        static let url = "https://api.github.com"
    }
    enum ContentType: String {
        case jsonType = "application/json"
    }
    enum HTTPHeaders: String {
        case contentType = "Content-Type"
    }
}
