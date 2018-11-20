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

    func create(objects: [Any], context: NSManagedObjectContext, callback: @escaping () -> Void) {
        context.perform { [weak self] in
            guard let _self = self else { return }
            for object in objects {
                if let repo = object as? RepoElement {
                    _ = RepoCoreDataModel.findOrCreate(repo: repo, context: context)
                }
            }
            try? context.save()
            try? context.parent?.save()
            _self.statistics(context)
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
    func update(objects: [Any], context: NSManagedObjectContext, callback: @escaping () -> Void) {
        context.perform { [weak self] in
            guard let _self = self else { return }
            for object in objects {
                if let repo = object as? RepoElement {
                    _ = RepoCoreDataModel.update(repo: repo, context: context)
                }
            }
            try? context.save()
            try? context.parent?.save()
            _self.statistics(context)
            callback()
        }
    }
    func delete(objects: [Any], context: NSManagedObjectContext, callback: @escaping () -> Void) {
        context.perform { [weak self] in
            guard let _self = self else { return }
            for object in objects {
                if let repo = object as? RepoElement {
                    _ = RepoCoreDataModel.remove(repo: repo, context: context)
                }
            }
            try? context.save()
            try? context.parent?.save()
            _self.statistics(context)
            callback()
        }
    }
    func find(objects: [Any], context: NSManagedObjectContext, callback: @escaping([RepoCoreDataModel]) -> Void) {
        context.perform {
            var repos = [RepoCoreDataModel]()
            for object in objects {
                if let element = object as? RepoElement, let repo = RepoCoreDataModel.find(repo: element, context: context) {
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
