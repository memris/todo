//
//  CoreDataManager.swift
//  todo
//
//  Created by USER on 23.11.2024.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
//        print("Init coredata manager")
        persistentContainer = NSPersistentContainer(name: "todo")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
