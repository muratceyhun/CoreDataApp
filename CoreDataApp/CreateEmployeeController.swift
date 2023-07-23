//
//  CreateEmployeeController.swift
//  CoreDataApp
//
//  Created by Murat Ceyhun Korpeoglu on 23.07.2023.
//

import UIKit

class CreateEmployeeController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .tealColor
        navigationItem.title = "Create an Employee"
        
        createCancelButton()
     
    }    
}
