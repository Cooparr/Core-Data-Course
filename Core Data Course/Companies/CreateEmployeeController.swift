//
//  CreateEmployeeController.swift
//  Core Data Course
//
//  Created by Alex Cooper on 21/05/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
//

import UIKit

class CreateEmployeeController: UIViewController {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Employee Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlueColor
        navigationItem.title = "Create Employee"
        setupCancelButton()
        _ = setupLightBlueBackgroundView(height: 50)
        
        setupUI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))

    }
    
    
    @objc func handleSave() {
        guard let employeeName = nameTextField.text else { return }
        let error = CoreDataManager.shared.createEmployee(employeeName: employeeName)
        if let error = error {
            let errorAlert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
            present(errorAlert, animated: true, completion: nil)
            errorAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    private func setupUI() {
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor).isActive = true
        
    }
}
