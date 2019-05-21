//
//  CreateCompanyController.swift
//  Core Data Course
//
//  Created by Alex Cooper on 01/05/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
//

import UIKit
import CoreData

protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
    func didEditCompany(company: Company)
}

class CreateCompanyController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var delegate: CreateCompanyControllerDelegate?
    var company: Company? {
        didSet {
            
            guard
                let founded = company?.founded,
                let imageData = company?.imageData
                else { return }
            
            nameTextField.text = company?.name
            datePicker.date = founded
            companyImageView.image = UIImage(data: imageData)
            setupCircularImageStyle()
        }
    }

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Company Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let datePicker: UIDatePicker = {
        let dP = UIDatePicker()
        dP.translatesAutoresizingMaskIntoConstraints = false
        dP.datePickerMode = .date
        return dP
    }()
    
    lazy var companyImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "selectEmptyImage"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    @objc private func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Ternary Operator
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupCancelButton()
        view.backgroundColor = .darkBlueColor
        
        // Nav Bar Button Items
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    @objc private func handleSave() {
        if company == nil {
            createCompanySave()
        } else {
            updateCompanySave()
        }
    }
    
    
    fileprivate func createCompanySave() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        company.setValue(nameTextField.text, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 1)
            company.setValue(imageData, forKey: "imageData")
        }
        
        // Perform Saving of Company
        do {
            try context.save()
            
            // Success
            dismiss(animated: true) {
                self.delegate?.didAddCompany(company: company as! Company)
            }
            
        } catch let saveErr {
            print("Failed to save:", saveErr)
        }
    }
    
    
    fileprivate func updateCompanySave() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        company?.name = nameTextField.text
        company?.founded = datePicker.date
        
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 1)
            company?.imageData = imageData
        }
        
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didEditCompany(company: self.company!)
            }
        } catch let saveErr {
            print("Error updating Company:", saveErr)
        }
    }
    
    
    fileprivate func setupUI(){
        let lightBlueBackgroundView = setupLightBlueBackgroundView(height: 350)
        
        view.addSubview(companyImageView)
        companyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor).isActive = true
        
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor).isActive = true
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            companyImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            companyImageView.image = originalImage
        }
        
        setupCircularImageStyle()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    private func setupCircularImageStyle() {
        companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
        companyImageView.layer.borderColor = UIColor.darkBlueColor.cgColor
        companyImageView.layer.borderWidth = 1.5
        companyImageView.clipsToBounds = true
    }
}
