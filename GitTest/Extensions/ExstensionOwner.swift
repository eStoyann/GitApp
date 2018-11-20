//
//  ExstensionOwner.swift
//  GitTest
//
//  Created by Evgeniy on 10/30/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import Foundation

extension Owner {
    init(object: OwnerCoreDataModel?) {
        self.id = object?.uid?.intValue ?? 0
        self.login = object?.name ?? "No Name"
    }
}
