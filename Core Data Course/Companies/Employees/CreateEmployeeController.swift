//
//  CreateEmployeeController.swift
//  Core Data Course
//
//  Created by Alex Cooper on 21/05/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
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
    
    let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "DD/MM/YYYY"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let employeeTypeSegmentedControl: UISegmentedControl = {
        let types = ["Executive", "SMT", "Staff"]
        let segCont = UISegmentedControl(items: types)
        segCont.selectedSegmentIndex = 0
        segCont.tintColor = UIColor.darkBlueColor
        segCont.translatesAutoresizingMaskIntoConstraints = false
        return segCont
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlueColor
        navigationItem.title = "Create Employee"
        setupCancelButton()
        
        setupUI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    
    @objc func handleSave() {
        guard
            let employeeName = nameTextField.text,
            let birthdayText = birthdayTextField.text,
            let company = self.company
            else { return }
        
        if birthdayText.isEmpty {
            presentAlertController(title: "Empty Birthday", message: "Please enter employees birthdate.")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
            presentAlertController(title: "Incorrect Date Format", message: "Birthday must follow DD/MM/YYYY format.")
            return
        }
        
        guard let employeeType = employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex) else { return }
        
        let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, birthdate: birthdayDate, employeeType: employeeType, company: company)
        
        if let error = tuple.1 {
            let errorAlert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
            present(errorAlert, animated: true, completion: nil)
            errorAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        } else {
            dismiss(animated: true) {
                guard let tupleEmployee = tuple.0 else { return }
                self.delegate?.didAddEmployee(employee: tupleEmployee)
            }
        }
    }
    
    
    private func presentAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
    }
    
    
    private func setupUI() {
        _ = setupLightBlueBackgroundView(height: 150)
        
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
        
        view.addSubview(birthdayLabel)
        birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        birthdayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        birthdayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        birthdayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(birthdayTextField)
        birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor).isActive = true
        birthdayTextField.leadingAnchor.constraint(equalTo: birthdayLabel.trailingAnchor).isActive = true
        birthdayTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        birthdayTextField.heightAnchor.constraint(equalTo: birthdayLabel.heightAnchor).isActive = true
        
        view.addSubview(employeeTypeSegmentedControl)
        employeeTypeSegmentedControl.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
        employeeTypeSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        employeeTypeSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        employeeTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }
}
