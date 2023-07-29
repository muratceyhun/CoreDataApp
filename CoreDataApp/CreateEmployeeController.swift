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
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "MM/DD/YYY"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        view.backgroundColor = .darkBlue
        navigationItem.title = "Create an Employee"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        createCancelButton()
        setupUI()
    }
    
    @objc func handleSave() {
        guard let employeeName = nameTextField.text else {return}
        guard let company = company else {return}
        guard let birthdayText = birthdayTextField.text else {return}
        
        if birthdayText.isEmpty {
            let alertController = UIAlertController(title: "Empty Date", message: "No info", preferredStyle: .alert)
            present(alertController, animated: true)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
//            let alertController = UIAlertController(title: "WRONG DATE!!", message: "Please enter a valid date...", preferredStyle: .actionSheet)
//            present(alertController, animated: true)
//            alertController.addAction(UIAlertAction(title: "Retry", style: .default))
            createAlertActions(title1: "Wrong Date", message: "Please enter a valid date", title2: "Retry", style: .default)
            return
        }
//        print(birthdayText)
//        print(birthdayDate)
       
        
        guard let employeeType = employeeTypeSegmentedController.titleForSegment(at: employeeTypeSegmentedController.selectedSegmentIndex) else {return}
        print(employeeType)
               
        let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, employeeType: employeeType, birthday: birthdayDate, company: company)
        
        if let error = tuple.1 {
            print("ERROR:", error)
        } else {
            dismiss(animated: true) {
                self.delegate?.didAddEmployee(employee: tuple.0!)
            }
        }
    }
    
    
    fileprivate func createAlertActions(title1: String, message: String, title2: String, style: UIAlertAction.Style ) {
        let alertController = UIAlertController(title: title1, message: message, preferredStyle: .alert)
        present(alertController, animated: true)
        alertController.addAction(UIAlertAction(title: title2, style: style))
    }
    
    
    let employeeTypeSegmentedController: UISegmentedControl = {
        let types = [EmployeeType.Executive.rawValue, EmployeeType.SeniorManagement.rawValue, EmployeeType.Staff.rawValue]
        let sc = UISegmentedControl(items: types)
        sc.selectedSegmentIndex = 0
        sc.tintColor = .darkBlue
        sc.backgroundColor = .white
        sc.selectedSegmentTintColor = .darkBlue
        sc.backgroundColor = .lightBlue
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    
    fileprivate func setupUI() {
        _ = createLightBlueBackgroundView(height: 200)

        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16).isActive = true
        nameTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        view.addSubview(birthdayLabel)
        birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        birthdayLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        birthdayLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        birthdayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(birthdayTextField)
        birthdayTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        birthdayTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor).isActive = true
        birthdayTextField.widthAnchor.constraint(equalToConstant: 130).isActive = true
        birthdayTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(employeeTypeSegmentedController)
        employeeTypeSegmentedController.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 16).isActive = true
        employeeTypeSegmentedController.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        employeeTypeSegmentedController.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        employeeTypeSegmentedController.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
    }
    
    
}
