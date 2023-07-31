//
//  Service.swift
//  CoreDataApp
//
//  Created by Murat Ceyhun Korpeoglu on 31.07.2023.
//

import UIKit

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
                JSONCompanies.forEach { JSONCompany in
                    print(JSONCompany.name)
                    JSONCompany.employees?.forEach({ employee in
                        print("  \(employee.name)")
                    })
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
