//
//  EmployeesController.swift
//  CoreDataApp
//
//  Created by Murat Ceyhun Korpeoglu on 23.07.2023.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }
    
    
    
    
    let cellID = "cellID"
    
    var company: Company?
    
    var employees = [Employee]()
    
    
    func fetchEmployees() {
        
        
        guard let employees = company?.employees?.allObjects as? [Employee] else {return}
        self.employees = employees
        
        
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//        let request = NSFetchRequest<Employee>(entityName: "Employee")
//        do {
//            let employees = try context.fetch(request)
//            self.employees = employees
//        } catch let err {
//            print("ERROR", err)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = .darkBlue
        navigationItem.title = company?.name
        fetchEmployees()
        createAddButton(selector: #selector(handleAddEmployee))
        
        
    }
    
    @objc func handleAddEmployee() {
        let createEmployeeController = CreateEmployeeController()
        let navController = UINavigationController(rootViewController: createEmployeeController)
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let employee = employees[indexPath.row]
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        if let taxID = employee.employeeInformation?.taxID {
//            cell.textLabel?.text = "\(employee.name ?? "") - taxID = \(taxID)"
//        } else {
//            cell.textLabel?.text = employee.name
//        }
        
        if let birthday = employee.employeeInformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd,yyyy"
            dateFormatter.locale = Locale(identifier: "EN")
            let dateString = dateFormatter.string(from: birthday)
            cell.textLabel?.text = "\(employee.name ?? "") - \(dateString)"
            
        } else {
            cell.textLabel?.text = employee.name
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
