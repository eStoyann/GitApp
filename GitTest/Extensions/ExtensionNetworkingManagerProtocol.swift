//
//  ExtensionNetworkingManagerProtocol.swift
//  GitTest
//
//  Created by Evgeniy on 11/20/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import Foundation
import Alamofire

typealias JSONDecodableCompletionHandler = (Codable?, HTTPURLResponse?, ErrorManager?) -> Void

extension NetworkingManagerProtocol {

    private func prepare<T: Codable>(router: NetworkingRouter, queue: DispatchQueue?, decodingType: T.Type, callback: @escaping JSONDecodableCompletionHandler) {
        Alamofire.request(router).response(queue: queue) { (response) in
            guard let HTTPResponse = response.response else {
                callback(nil, nil, .HTTPRequestFailed)
                return
            }
            guard let data = response.data else {
                if response.error != nil {
                    callback(nil, HTTPResponse, .InvalidData)
                }
                return
            }
            switch HTTPResponse.statusCode {
            case 200:
                do {
                    let decode = try JSONDecoder().decode(decodingType, from: data)
                    callback(decode, HTTPResponse, nil)
                } catch {
                    callback(nil, HTTPResponse, .JSONConversionFailure)
                }
            default:
                print("We have got response code: \(HTTPResponse.statusCode)")
                callback(nil, HTTPResponse, .HTTPResponseUnsuccessful)
            }
        }
    }
    func fetchRequest<T: Codable>(router: NetworkingRouter, queue: DispatchQueue?, decoding: @escaping (Codable) -> T?, callback: @escaping (NetworkingResult<T, ErrorManager>) -> Void) {
        prepare(router: router, queue: queue, decodingType: T.self) { (json, responce, error) in
            guard let json = json else {
                if let error = error {
                    callback(.Failure(error))
                } else {
                    callback(.Failure(.InvalidData))
                }
                return
            }
            if let value = decoding(json) {
                callback(.Success(value))
            } else {
                callback(.Failure(.JSONDecodingFailure))
            }
        }
    }
}
