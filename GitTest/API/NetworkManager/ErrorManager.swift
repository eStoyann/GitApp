//
//  ErrorHandler.swift
//  GitTest
//
//  Created by Evgeniy on 11/1/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import Foundation

enum ErrorManager: Error {
    case HTTPRequestFailed
    case InvalidData
    case JSONConversionFailure
    case HTTPResponseUnsuccessful
    case JSONDecodingFailure

    var localizedDescription: String {
        switch self {
        case .HTTPRequestFailed: return "Request Failed"
        case .InvalidData: return "Invalid Data"
        case .HTTPResponseUnsuccessful: return "Response Unsuccessful"
        case .JSONDecodingFailure: return "JSON Decoding Failure"
        case .JSONConversionFailure: return "JSON Conversion Failure"
        }
    }
}
