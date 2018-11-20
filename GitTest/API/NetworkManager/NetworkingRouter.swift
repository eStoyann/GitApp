//
//  NetworkingRouter.swift
//  GitTest
//
//  Created by Evgeniy on 10/30/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkingRouter: URLRequestConvertible {

    case repos(login: String)

    //MARK: Private computed property
    private var parameters: Parameters? { return nil }
    private var httpMethod: HTTPMethod {
        switch self {
        case .repos: return .get
        }
    }
    private var urlPath: String {
        switch self {
        case let .repos(login): return "/users/\(login)/repos"
        }
    }
    
    //MARK: Public methods
    func asURLRequest() throws -> URLRequest {
        let url = try RequestParameters.Servers.url.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(urlPath))
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.setValue(RequestParameters.ContentType.jsonType.rawValue,
                            forHTTPHeaderField: RequestParameters.HTTPHeaders.contentType.rawValue)
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest
    }
}
