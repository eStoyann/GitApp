//
//  NetworkingManagerProtocol.swift
//  GitTest
//
//  Created by Evgeniy on 11/20/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import Foundation

protocol NetworkingManagerProtocol {
    func fetchRequest<T: Codable>(router: NetworkingRouter, queue: DispatchQueue?, decoding: @escaping (Codable) -> T?, callback: @escaping (NetworkingResult<T, ErrorManager>) -> Void)
}
