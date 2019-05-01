//
//  CoreDataManager.swift
//  Core Data Course
//
//  Created by Alex Cooper on 01/05/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
//

import CoreData

struct CoreDataManager {
    //Singleton - Will be retained as long as application is alive, including it's properties. Memory never reclaimed!
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModels")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Failed to load store: \(err)")
            }
        }
        return container
    }()
}
