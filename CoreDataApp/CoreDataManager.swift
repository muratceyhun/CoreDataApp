//
//  CoreDataManager.swift
//  CoreDataApp
//
//  Created by Murat Ceyhun Korpeoglu on 19.07.2023.
//

import CoreData


class CoreDataManager {
    
    static let shared  = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataApp")
        container.loadPersistentStores { stroreDescription, err in
            if let err = err {
                print("Error", err)
            }
        }
        return container
    }()
}
