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
    
    func createEmployee(employeeName: String, birthday: Date, company: Company) -> (Employee? ,Error?) {
        let context = persistentContainer.viewContext
        // create an employee
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        
        employee.company = company
   
        
        employee.setValue(employeeName, forKey: "name")
        
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        
        employeeInformation.taxID = "518"
        employeeInformation.birthday = birthday
//        employeeInformation.setValue("518", forKey: "taxID")
        employee.employeeInformation = employeeInformation
        
        
        do {
            try context.save()
            return (employee, nil)
        } catch let err {
            print("ERROR", err)
            return (nil, err)
        }
    }
    
}
