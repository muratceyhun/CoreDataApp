//
//  CompaniesController+UITableView.swift
//  CoreDataApp
//
//  Created by Murat Ceyhun Korpeoglu on 23.07.2023.
//

import UIKit

extension CompaniesController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let employeesController = EmployeesController()
        let company = companies[indexPath.row]
        employeesController.company = company
        navigationController?.pushViewController(employeesController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let company = self.companies[indexPath.item]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            
            // Remove the company from tableView
            
            self.companies.remove(at: indexPath.item)
            self.tableView.deleteRows(at: [indexPath], with: .top )

            
            // Delete the company from Core Data
            print("try to delete \(company.name ?? "")")
            let context = CoreDataManager.shared.persistentContainer.viewContext
            context.delete(company)
            
            do {
                try context.save()
            } catch let err {
                print("Error ---> ", err)
            }
        }
        
        deleteAction.backgroundColor = .lightRed

        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            print("Editing \(company.name ?? "")")
            let createCompanyVC = CreateCompanyController()
            createCompanyVC.delegate = self
            createCompanyVC.company = self.companies[indexPath.item]
            let navController = UINavigationController(rootViewController: createCompanyVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        }
   
        let actions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        editAction.backgroundColor = UIColor.darkBlue
        return actions
        
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No company available..."
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ? 150 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        self.tableView.sectionHeaderTopPadding = 0
        view.backgroundColor = .lightBlue
        return view
    }
    


    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! CompanyCell
        let company = companies[indexPath.item]
        cell.company = company

        return cell
    }
    
}
