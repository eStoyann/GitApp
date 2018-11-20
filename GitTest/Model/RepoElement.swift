//
//  RepoElement.swift
//  GitTest
//
//  Created by Evgeniy on 10/30/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import Foundation

typealias Repo = [RepoElement]

struct RepoElement: Codable {
    var id: Int
    var name: String
    var description: String?
    var url: URL?
    var size: Int
    var stars: Int?
    var watchers: Int
    var forks: Int
    var created: Date?
    var updated: Date?
    var pushed: Date?
    var language: String?
    var owner: Owner
    private enum CodignKeys: String, CodingKey {
        case id, owner, name, description, url, size, stars = "stargazers_count", watchers, forks, created = "created_at", updated = "updated_at", pushed = "pushed_at", language
    }
}
struct Owner: Codable {
    var id: Int
    var login: String
    private enum CodignKeys: String, CodingKey {
        case id, login = "login", avatar = "avatar_url"
    }
}
