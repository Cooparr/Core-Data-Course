//
//  CreateCompanyController.swift
//  Core Data Course
//
//  Created by Alex Cooper on 01/05/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
//

import UIKit

class CreateCompanyController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Company"
        view.backgroundColor = .darkBlueColor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
}
