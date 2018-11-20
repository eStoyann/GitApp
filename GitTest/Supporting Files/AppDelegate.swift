//
//  AppDelegate.swift
//  GitTest
//
//  Created by Evgeniy on 10/30/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let coreDataStack = CoreDataStack(database: "GitTest")

    var window: UIWindow?

    var backgoundContext: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).coreDataStack.backgroundContext
    }
}
