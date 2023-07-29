//
//  EmployeesController.swift
//  CoreDataApp
//
//  Created by Murat Ceyhun Korpeoglu on 23.07.2023.
//

import UIKit
import CoreData

class IndentedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = rect.inset(by: insets)
        super.drawText(in: customRect)
    }
}


class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee) {
        
//        employees.append(employee)
//        fetchEmployees()
//        tableView.reloadData()
        guard let section = employeeTypes.firstIndex(of: employee.type ?? "") else {return}
        let row = allEmployees[section].count
        let insertionIndexPath = IndexPath(row: row, section: section)
        allEmployees[section].append(employee)
        tableView.insertRows(at: [insertionIndexPath], with: .middle)
        
    }
    
    
    
    
    let cellID = "cellID"
    
    var company: Company?
    
//    var employees = [Employee]()
    
    var allEmployees = [[Employee]]()
    
    var employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue
    ]
    
    
    func fetchEmployees() {
        
        guard let employees = company?.employees?.allObjects as? [Employee] else {return}
//        self.employees = employees
        allEmployees = []
          
        employeeTypes.forEach { employeeType in
            allEmployees.append(
                employees.filter{$0.type == employeeType}
            )
        }
        
//
//        let executives = employees.filter { employee in
//            return employee.type ==  EmployeeType.Executive.rawValue
//        }
//
//        let seniorManagement = employees.filter { employee in
//            return employee.type == EmployeeType.SeniorManagement.rawValue
//        }
//
//        let staff = employees.filter {$0.type == EmployeeType.Staff.rawValue}
//
//        allEmployees = [executives, seniorManagement, staff]

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
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allEmployees[section].count
        
//        if section == 0 {
//            return shortNames.count
//        }
//        return longNames.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let label = IndentedLabel()
        
        label.text = employeeTypes[section]
        
//
//        if section == 0 {
//            label.text = EmployeeType.Executive.rawValue
//        } else if section == 1 {
//            label.text = EmployeeType.SeniorManagement.rawValue
//        } else {
//            label.text = EmployeeType.Staff.rawValue
//        }
        label.textColor = .darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        self.tableView.sectionHeaderTopPadding = 0
        label.backgroundColor = .lightBlue
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
//        let employee = indexPath.section == 0 ? shortNames[indexPath.row] : longNames[indexPath.row]
        let employee = allEmployees[indexPath.section][indexPath.row]
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
