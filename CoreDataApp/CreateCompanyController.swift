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
    func didEditCompany(company: Company)
}


class CreateCompanyController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var company: Company? {
        didSet {
            nameTextField.text = company?.name
            guard let foundedDate = company?.founded else {return}
            datePicker.date = foundedDate
            guard let imageData = company?.imageData else {return}
            companyImageView.image = UIImage(data: imageData)
            setupCircularImageStyle()
        }
    }
    
    fileprivate func setupCircularImageStyle() {
        companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
        companyImageView.clipsToBounds = true
        companyImageView.layer.borderColor = UIColor.darkBlue.cgColor
        companyImageView.layer.borderWidth = 2
    }
    
    var delegate: CreateCompanyControllerDelegate?
    
    lazy var companyImageView: UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "select_photo_empty"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAddPhoto)))
        return imageView
    }()
    
    @objc func handleAddPhoto() {
        let imagePickerController = UIImagePickerController()
//        imagePickerController.modalPresentationStyle = .fullScreen
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let originalImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            companyImageView.image = originalImage

        } else if let editedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            companyImageView.image = editedImage
        }
        setupCircularImageStyle()
        dismiss(animated: true)
    }
    
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
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .wheels
        dp.locale = Locale(identifier: "EN")

        return dp
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        view.backgroundColor = .darkBlue
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        setupUI()

    }
    
    @objc func handleSave() {
        
        if company == nil {
            createCompany()
        } else {
            saveCompanyChanges()
        }
    }
    
    fileprivate func saveCompanyChanges() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        self.company?.name = nameTextField.text
        self.company?.founded = datePicker.date
        
        guard let companyImage = companyImageView.image else {return}
        let imageData = companyImage.jpegData(compressionQuality: 0.8)
        self.company?.imageData = imageData
        
        do {
            try context.save()
            guard let company = company else {return}
            dismiss(animated: true) {
                 self.delegate?.didEditCompany(company: company)
            }
        } catch let err {
            print("ERROR: EDIT", err)
        }
     }
    
    fileprivate func createCompany() {
        
        // Initialize Core Data Stack

        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        
        
        company.setValue(nameTextField.text, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        
        guard let companyImage = companyImageView.image else {return}
        let imageData = companyImage.jpegData(compressionQuality: 0.8)
        company.setValue(imageData, forKey: "imageData")
        
        // Perform the save
        
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didAddCompany(company: company as! Company)
                print("SaveCompany works !!!!")
            }
         } catch let err {
            print("Saving to core data error", err)
        }
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
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 416).isActive = true
        
        view.addSubview(companyImageView)
        companyImageView.topAnchor.constraint(equalTo: lightBlueBackgroundView.topAnchor, constant: 24).isActive = true
        companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true

        
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 20).isActive = true
        nameTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor).isActive = true
        
    }

}
