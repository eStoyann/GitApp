//
//  ExtensionRepoElement.swift
//  GitTest
//
//  Created by Evgeniy on 10/30/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import Foundation

extension RepoElement {
    init(object: RepoCoreDataModel) {
        self.description = object.descriptions
        self.forks = object.forks?.intValue ?? 0
        self.id = object.uid?.intValue ?? 0
        self.language = object.language
        self.name = object.name ?? ""
        self.owner = Owner(object: object.owner)
        self.pushed = object.pushedRepo
        self.size = object.size?.intValue ?? 0
        self.stars = object.watchers?.intValue ?? 0
        self.updated = object.updatedRepo
        self.created = object.createdRepo
        self.url = object.url != nil ? URL(fileURLWithPath: object.url!) : URL(fileURLWithPath: "")
        self.watchers = object.watchers?.intValue ?? 0
    }
}
