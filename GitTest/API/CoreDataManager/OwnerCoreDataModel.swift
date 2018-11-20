//
//  OwnerCoreDataModel.swift
//  GitTest
//
//  Created by Evgeniy on 10/30/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import UIKit
import CoreData

class OwnerCoreDataModel: NSManagedObject {

    class func findOrCreate(owner: Owner, context: NSManagedObjectContext) -> OwnerCoreDataModel? {

        let request: NSFetchRequest<OwnerCoreDataModel> = NSFetchRequest(entityName: "OwnerCoreDataModel")
        request.predicate = NSPredicate(format: "uid = %@", NSNumber(value: owner.id))

        if let resultOwner = (try? context.fetch(request))?.first {
            return resultOwner
        } else if let newOwner = NSEntityDescription.insertNewObject(forEntityName: "OwnerCoreDataModel", into: context) as? OwnerCoreDataModel {
            newOwner.uid = NSNumber(value: owner.id)
            newOwner.name = owner.login
            return newOwner
        }
        return nil
    }

    class func update(owner: Owner, context: NSManagedObjectContext) -> OwnerCoreDataModel? {

        let request: NSFetchRequest<OwnerCoreDataModel> = NSFetchRequest(entityName: "OwnerCoreDataModel")
        request.predicate = NSPredicate(format: "uid = %@", NSNumber(value: owner.id))

        if let resultOwner = (try? context.fetch(request))?.first {
            let newOwner = resultOwner
            newOwner.uid = NSNumber(value: owner.id)
            newOwner.name = owner.login
            return newOwner
        }
        return nil
    }
}
