//
//  ViewController.swift
//  CoreDataApp
//
//  Created by Murat Ceyhun Korpeoglu on 14.07.2023.
//

import UIKit
import CoreData


class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
    
    var companies = [Company]()
    
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1 , section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func fetchCompanies() {
        
        let persistentContainer = NSPersistentContainer(name: "CoreDataApp")
        persistentContainer.loadPersistentStores { storeDescription, err in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company >(entityName: "Company")
        do {
          let companies = try context.fetch(fetchRequest)
            companies.forEach { company in
                print(company.name ?? "")
            }
        } catch let err {
            print("Failed to fetch  companies:", err)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.backgroundColor = .tealColor
        let company = companies[indexPath.item]
        cell.textLabel?.text = company.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
}







