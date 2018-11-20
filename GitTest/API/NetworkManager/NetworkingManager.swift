//
//  NetworkingManager.swift
//  GitTest
//
//  Created by Evgeniy on 10/30/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import Foundation
import Alamofire

final class NetworkingManager: NetworkingManagerProtocol {

    static let shared = NetworkingManager()

    private init() {}

    func fetchRepos(login: String, queue: DispatchQueue?, callback: @escaping (NetworkingResult<Repo, ErrorManager>) -> Void) {
        fetchRequest(router: NetworkingRouter.repos(login: login), queue: queue, decoding: { (json) -> (Repo)? in
            guard let repo = json as? Repo else { return nil }
            return repo
        }, callback: callback)
    }


//    func fetchRequest(login: String, queue: DispatchQueue?, callback: @escaping (Repo?, ErrorManager?) -> Void) {
//        self.prepare(router: NetworkingRouter.repos(login: login), queue: queue, callback: callback)
//    }
//
//    private func prepare<M: Codable>(router: NetworkingRouter, queue: DispatchQueue?, callback: @escaping (M?, ErrorManager?) -> Void) {
//        Alamofire.request(router).response(queue: queue) { (response) in
//            guard let data = response.data, response.error == nil else {
//                if response.error != nil {
//                    print("***ERROR response:", response.error!.localizedDescription)
//                    callback(nil, .IthernetConncetion)
//                }
//                return
//            }
//            do {
//                let decoder = try JSONDecoder().decode(M.self, from: data)
//                print("***Success")
//                callback(decoder, nil)
//            } catch let error {
//                print("***ERROR decode:", error.localizedDescription)
//                callback(nil, .IncorrectInputData)
//            }
//        }
//    }
}
