//
//  CompaniesAutoUpdateController.swift
//  CoreDataApp
//
//  Created by Murat Ceyhun Korpeoglu on 30.07.2023.
//

import UIKit
import CoreData


class CompaniesAutoUpdateController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    lazy var fetchedResultController: NSFetchedResultsController = {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        request.sortDescriptors = [
                NSSortDescriptor(key: "name", ascending: true)
        ]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch let err {
            print("ERROR:", err)
        }
        return frc
    }()
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
     
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
     
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
     
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
  
    
    @objc func handleAdd() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = Company(context: context)
        company.name = "Casper"
        try? context.save()
        
    }
    
    
    @objc func handleDelete() {
        
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS %@", "p")

        let context = CoreDataManager.shared.persistentContainer.viewContext
        let companiesWithB = try? context.fetch(request)

        companiesWithB?.forEach({ company in
            context.delete(company)
        })

        try? context.save()

    }
    
    
    
    override func viewDidLoad() {
        navigationItem.title = "Company Auto Updates"
        super.viewDidLoad()
        view.backgroundColor = .darkBlue
        navigationItem.leftBarButtonItems = [ UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd)),
                                              UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDelete))
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellID)
        fetchedResultController.fetchedObjects?.forEach({ company in
            print(company.name ?? "")
        })
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.text = fetchedResultController.sectionIndexTitles[section]
        view.backgroundColor = .lightBlue
        return label
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? .zero
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        return fetchedResultController.sections![section].numberOfObjects
    }
    
    let cellID = "cellID"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CompanyCell
        let company = fetchedResultController.object(at: indexPath)
        cell.company = company
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
