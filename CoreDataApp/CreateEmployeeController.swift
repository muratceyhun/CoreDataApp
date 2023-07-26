//
//  CreateEmployeeController.swift
//  CoreDataApp
//
//  Created by Murat Ceyhun Korpeoglu on 23.07.2023.
//

import UIKit

protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
    
    var company: Company?
    
    var delegate: CreateEmployeeControllerDelegate?

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
         
        view.backgroundColor = .darkBlue
        navigationItem.title = "Create an Employee"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        createCancelButton()
        _ = createLightBlueBackgroundView(height: 150)
        setupUI()
    }
    
    @objc func handleSave() {
        guard let employeeName = nameTextField.text else {return}
        guard let company =  company else {return}
        let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, company: company)
        
        if let error = tuple.1 {
            print("ERROR:", error)
        } else {
            dismiss(animated: true) {
                self.delegate?.didAddEmployee(employee: tuple.0!)
            }
        }
    }
    
    
    fileprivate func setupUI() {
        
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
