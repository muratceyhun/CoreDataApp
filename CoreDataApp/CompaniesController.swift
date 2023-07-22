//
//  ViewController.swift
//  CoreDataApp
//
//  Created by Murat Ceyhun Korpeoglu on 14.07.2023.
//

import UIKit
import CoreData


class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
     func didEditCompany(company: Company) {
        let row = companies.firstIndex(of: company)
        
         let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
    
    var companies = [Company]()
    
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1 , section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
 
    
    func fetchCompanies() {
      
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company >(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            companies.forEach { company in
                print(company.name ?? "")
            }
            self.companies = companies
            self.tableView.reloadData()
        } catch let err {
            print("Failed to fetch  companies:", err)
        }
    }
    
    fileprivate func editResetbutton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(handleReset))
    }
    
    @objc func handleReset() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest() )
        do {
            try context.execute(batchDeleteRequest)
            var indexPathsToRemove = [IndexPath]()
            
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
        } catch let err {
            print("ERROR:", err)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        editResetbutton()
        fetchCompanies()
        view.backgroundColor = .white
        navigationItem.title = "Companies"
//        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .darkBlue
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    @objc func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        let navController = CustomNavController(rootViewController: createCompanyController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
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
  

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.backgroundColor = .tealColor
        let company = companies[indexPath.item]
        if let companyName = company.name, let foundedDate = company.founded {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            dateFormatter.locale = Locale(identifier: "EN")
            let dateString = dateFormatter.string(from: foundedDate)
//            let locale = Locale(identifier: "EN")
//            foundedDate.description(with: locale)
            cell.textLabel?.text = "\(companyName) | Founded: \(dateString)"
        } else {
            cell.textLabel?.text = company.name
        }
         cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.imageView?.image = UIImage(named: "select_photo_empty")
        if let imageData = company.imageData {
            cell.imageView?.image = UIImage(data: imageData)
        }
        return cell
    }
    
}







