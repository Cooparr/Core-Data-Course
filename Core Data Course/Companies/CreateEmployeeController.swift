//
//  CreateEmployeeController.swift
//  Core Data Course
//
//  Created by Alex Cooper on 21/05/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
//

import UIKit

class CreateEmployeeController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Employee"
        setupCancelButton()
        view.backgroundColor = .darkBlueColor
    }
}
