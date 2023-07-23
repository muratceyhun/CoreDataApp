//
//  EmployeesController.swift
//  CoreDataApp
//
//  Created by Murat Ceyhun Korpeoglu on 23.07.2023.
//

import UIKit

class EmployeesController: UITableViewController {
    
    var company: Company?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .darkBlue
        navigationItem.title = company?.name

        createAddButton(selector: #selector(handleAddEmployee))
        
        
    }
    
    @objc func handleAddEmployee() {
        let createEmployeeController = CreateEmployeeController()
        let navController = UINavigationController(rootViewController: createEmployeeController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    
}
