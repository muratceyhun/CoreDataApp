//
//  CreateCompanyController.swift
//  CoreDataApp
//
//  Created by Murat Ceyhun Korpeoglu on 16.07.2023.
//

import UIKit
import CoreData

protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
}


class CreateCompanyController: UIViewController {
    
    
    var delegate: CreateCompanyControllerDelegate?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Company Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        view.backgroundColor = .darkBlue
        navigationItem.title = "Create Company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        setupUI()

    }
    
    @objc func handleSave() {
        
        // Initialize Core Data Stack
        
        let persistentContainer = NSPersistentContainer(name: "CoreDataApp")
        persistentContainer.loadPersistentStores { storeDescription, err in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        let context = persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        company.setValue(nameTextField.text, forKey: "name")
        
        // Perform the save
        
        do {
            try context.save()
         } catch let err {
            print("Saving to core data error", err)
        }
        
        
        
        
        
        
        
//        guard let companyName = nameTextField.text else {return}
//        let company = Company(name: companyName, founded: Date())
//        dismiss(animated: true) {
//            self.delegate?.didAddCompany(company: company)
//        }
    }
    
    @objc func handleCancel() {
        
        dismiss(animated: true)
    }
    
    func setupUI() {
        
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = .lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lightBlueBackgroundView)
        
        lightBlueBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        lightBlueBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        

        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 20).isActive = true
        nameTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }

}
