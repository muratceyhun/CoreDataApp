//
//  UIViewController+Helpers.swift
//  CoreDataApp
//
//  Created by Murat Ceyhun Korpeoglu on 23.07.2023.
//

import UIKit

extension UIViewController {
    
    func createAddButton(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: selector)
    }
    
    func createCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
}
