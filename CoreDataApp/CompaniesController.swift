//
//  ViewController.swift
//  CoreDataApp
//
//  Created by Murat Ceyhun Korpeoglu on 14.07.2023.
//

import UIKit
import CoreData


class CompaniesController: UITableViewController {

    var companies = [Company]()
    
    fileprivate func editResetbutton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(handleReset))
    }
    
    @objc func handleReset() {
        print("Resetttt")
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
    
    @objc func doWork() {
//            let context = CoreDataManager.shared.persistentContainer.viewContext
            CoreDataManager.shared.persistentContainer.performBackgroundTask { backgroundContext in
                (0...5).forEach { number in
                    print(number)
                    let company = Company(context: backgroundContext)
                    company.name = String(number)
                }
                do {
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        self.tableView.reloadData()
                    }
                 } catch let err {
                    print("Error", err)
                }
            }

    }
    
    @objc func doUpdates() {
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask { backgroundContext in
            let request: NSFetchRequest<Company> = Company.fetchRequest() 
            do {
                let companies = try backgroundContext.fetch(request)
                companies.forEach { company in
                    guard let name = company.name else {return}
                    print(name)
                    company.name = "C:\(name)"
                    try? backgroundContext.save()
                    
                    DispatchQueue.main.async {
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        self.tableView.reloadData()
                    }
                }
            } catch let err {
                print("ERROR", err)
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Do Updates", style: .plain, target: self, action: #selector(doUpdates))
        ]
//        editResetbutton()
        self.companies = CoreDataManager.shared.fetchCompanies()
        view.backgroundColor = .white
        navigationItem.title = "Companies"
        tableView.backgroundColor = .darkBlue
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .white
        createAddButton(selector: #selector(handleAddCompany))
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellID")
    }
    
    @objc func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        let navController = CustomNavController(rootViewController: createCompanyController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }  
}







