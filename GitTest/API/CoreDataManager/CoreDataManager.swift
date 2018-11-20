//
//  CoreDataManager.swift
//  GitTest
//
//  Created by Evgeniy on 10/30/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {

    private static let instance = CoreDataManager()

    static var shared: CoreDataManager {
        return instance
    }

    private init() {}

    func create(objects: Repo, context: NSManagedObjectContext, callback: @escaping () -> Void) {
        context.perform { [weak self] in
            for object in objects {
                _ = RepoCoreDataModel.findOrCreate(repo: object, context: context)
            }
            try? context.save()
            try? context.parent?.save()
            self?.statistics(context)
            callback()
        }
    }
    func read<T: NSManagedObject>(entityName: String, context: NSManagedObjectContext, callback: @escaping ([T]?) -> Void) {
        context.perform {
            let request: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
            if let matches = try? context.fetch(request) {
                callback(matches)
            } else {
                callback(nil)
            }
        }
    }
    func update(objects: Repo, context: NSManagedObjectContext, callback: @escaping () -> Void) {
        context.perform { [weak self] in
            for object in objects {
                _ = RepoCoreDataModel.update(repo: object, context: context)
            }
            try? context.save()
            try? context.parent?.save()
            self?.statistics(context)
            callback()
        }
    }
    func delete(objects: Repo, context: NSManagedObjectContext, callback: @escaping () -> Void) {
        context.perform { [weak self] in
            for object in objects {
                _ = RepoCoreDataModel.remove(repo: object, context: context)
            }
            try? context.save()
            try? context.parent?.save()
            self?.statistics(context)
            callback()
        }
    }
    func find(objects: Repo, context: NSManagedObjectContext, callback: @escaping([RepoCoreDataModel]) -> Void) {
        context.perform {
            var repos: [RepoCoreDataModel] = []
            for object in objects {
                if let repo = RepoCoreDataModel.find(repo: object, context: context) {
                    repos.append(repo)
                }
            }
            callback(repos)
        }
    }
    private func statistics(_ context: NSManagedObjectContext) {
        context.perform {
            let request: NSFetchRequest<RepoCoreDataModel> = NSFetchRequest(entityName: "RepoCoreDataModel")
            if let matchesCount = (try? context.fetch(request))?.count {
                print("\(matchesCount) objects")
            }
        }
    }
}
