//
//  CreateCompanyController.swift
//  CoreDataApp
//
//  Created by Murat Ceyhun Korpeoglu on 16.07.2023.
//

import UIKit

class CreateCompanyController: UIViewController {
    override func viewDidLoad() {
        navigationItem.title = "Creeate Company"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        
        super.viewDidLoad()
        view.backgroundColor = .darkBlue
    }
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }

}
