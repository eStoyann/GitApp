//
//  RepoCoreDataModel.swift
//  GitTest
//
//  Created by Evgeniy on 10/30/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import UIKit
import CoreData

class RepoCoreDataModel: NSManagedObject {

    class func findOrCreate(repo: RepoElement, context: NSManagedObjectContext) -> RepoCoreDataModel? {

        let request: NSFetchRequest<RepoCoreDataModel> = NSFetchRequest(entityName: typeName)
        request.predicate = NSPredicate(format: "uid = %@", NSNumber(value: repo.id))

        if let resultRepo = (try? context.fetch(request))?.first {
            return resultRepo
        } else if let newRepo = NSEntityDescription.insertNewObject(forEntityName: typeName, into: context) as? RepoCoreDataModel {
            newRepo.uid = NSNumber(value: repo.id)
            newRepo.name = repo.name
            newRepo.url = repo.url != nil ? repo.url!.absoluteString : nil
            newRepo.language = repo.language
            newRepo.descriptions = repo.description
            newRepo.createdRepo = repo.created
            newRepo.updatedRepo = repo.updated
            newRepo.pushedRepo = repo.pushed
            newRepo.forks = NSNumber(value: repo.forks)
            newRepo.size = NSNumber(value: repo.size)
            newRepo.stars = NSNumber(value: repo.watchers)
            newRepo.watchers = NSNumber(value: repo.watchers)
            newRepo.owner = OwnerCoreDataModel.findOrCreate(owner: repo.owner, context: context)
            return newRepo
        }
        return nil
    }

    class func remove(repo: RepoElement, context: NSManagedObjectContext) -> RepoCoreDataModel? {

        let request: NSFetchRequest<RepoCoreDataModel> = NSFetchRequest(entityName: typeName)
        request.predicate = NSPredicate(format: "uid = %@", NSNumber(value: repo.id))

        if let resultRepo = (try? context.fetch(request))?.first {
            context.delete(resultRepo)
            return resultRepo
        }
        return nil
    }

    class func update(repo: RepoElement, context: NSManagedObjectContext) -> RepoCoreDataModel? {

        let request: NSFetchRequest<RepoCoreDataModel> = NSFetchRequest(entityName: typeName)
        request.predicate = NSPredicate(format: "uid = %@", NSNumber(value: repo.id))

        if let resultRepo = (try? context.fetch(request))?.first {
            let newRepo = resultRepo
            newRepo.uid = NSNumber(value: repo.id)
            newRepo.url = repo.url != nil ? repo.url!.absoluteString : nil
            newRepo.name = repo.name
            newRepo.language = repo.language
            newRepo.descriptions = repo.description
            newRepo.createdRepo = repo.created
            newRepo.updatedRepo = repo.updated
            newRepo.pushedRepo = repo.pushed
            newRepo.forks = NSNumber(value: repo.forks)
            newRepo.size = NSNumber(value: repo.size)
            newRepo.stars = NSNumber(value: repo.watchers)
            newRepo.watchers = NSNumber(value: repo.watchers)
            newRepo.owner = OwnerCoreDataModel.update(owner: repo.owner, context: context)
            return newRepo
        }
        return nil
    }
    
    class func find(repo: RepoElement, context: NSManagedObjectContext) -> RepoCoreDataModel? {

        let request: NSFetchRequest<RepoCoreDataModel> = NSFetchRequest(entityName: typeName)
        request.predicate = NSPredicate(format: "uid = %@", NSNumber(value: repo.id))

        if let resultRepos = (try? context.fetch(request))?.first {
            return resultRepos
        }
        return nil
    }
}
