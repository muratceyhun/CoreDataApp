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
    
    
    func fetchCompanies() -> [Company] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company >(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
       
        } catch let err {
            print("Failed to fetch  companies:", err)
            return []
        }
    }
    
    func createEmployee(employeeName: String) -> Error? {
        let context = persistentContainer.viewContext
        // create an employee
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context)
        employee.setValue(employeeName, forKey: "name")
        do {
            try context.save()
            return nil
        } catch let err {
            print("ERROR", err)
            return err
        }
    }
    
}
