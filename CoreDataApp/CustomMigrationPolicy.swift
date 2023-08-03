//
//  CustomMigrationPolicy.swift
//  CoreDataApp
//
//  Created by Murat Ceyhun Korpeoglu on 3.08.2023.
//

import CoreData


class CustomMigrationPolicy: NSEntityMigrationPolicy  {
    
    
    
    @objc func transformNumEmployees(forNum: NSNumber) -> String {
        if forNum.int16Value < 200 {
            return "small "
        } else {
            return "very large"
        }
    }
    
}
