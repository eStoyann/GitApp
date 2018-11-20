//
//  NetworkingResult.swift
//  GitTest
//
//  Created by Evgeniy on 11/20/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import Foundation

enum NetworkingResult<T, E> where E: Error {
    case Success(T)
    case Failure(E)
}
