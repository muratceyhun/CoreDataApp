//
//  Service.swift
//  CoreDataApp
//
//  Created by Murat Ceyhun Korpeoglu on 31.07.2023.
//

import UIKit
import CoreData

class Service {
    static let shared = Service()
    func downloadCompaniesFromServer() {
        
        let url = "https://api.letsbuildthatapp.com/intermediate_training/companies"
        
        print("Attempt to download companies")
        guard let urlString = URL(string: url) else {return}
        let urlRequest = URLRequest(url: urlString)
        
        
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            print("Finished downloading...")
            
            
            if let error = error {
                print("Failed to get data :", error)
                return
            }
            
            guard let data = data else {return}
            guard let string = String(data: data, encoding: .utf8) else {return}
            print(string)
            
            do {
                let JSONCompanies = try JSONDecoder().decode([JSONCompany].self, from: data)
                
                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
                
                JSONCompanies.forEach { JSONCompany in
                    print(JSONCompany.name)
                    
                    let company = Company(context: privateContext)
                    
                    company.name = JSONCompany.name
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    guard let foundedString = JSONCompany.founded else {return}
                    let foundedDate = dateFormatter.date(from: foundedString)
                    company.founded = foundedDate
               
            
                    JSONCompany.employees?.forEach({ JSONEmployee in
                        print("  \(JSONEmployee.name)")
                        
                        let employee = Employee(context: privateContext)
                        employee.fullName = JSONEmployee.name
                        employee.type = JSONEmployee.type
                        
                        let employeeInformation = EmployeeInformation(context: privateContext)
                        
                        guard let employeeBirthday = JSONEmployee.birthday else {return}
                        let date = dateFormatter.date(from: employeeBirthday)
                        employeeInformation.birthday = date
                        
                        employee.employeeInformation = employeeInformation
                        
                        employee.company = company
                        
                    })
                    
                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                    } catch let err {
                        print("ERROR:",  err)
                    }
                }
                
                
            } catch let error {
                print("Failed to decode data", error)
            }
        }.resume()
    }
}


struct JSONCompany: Decodable {
    let name: String
    let founded: String?
    let photoUrl: String
    let employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
    let name: String
    let type: String?
    let birthday: String?
}
