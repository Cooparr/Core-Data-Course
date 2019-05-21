//
//  EmployeesController.swift
//  Core Data Course
//
//  Created by Alex Cooper on 21/05/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
//

import UIKit

class EmployeesController: UITableViewController {
    
    var company: Company?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .darkBlueColor
        setupNavBarPlusButton(selector: #selector(handleAdd))
    }
    
    @objc func handleAdd() {

        let createEmployeesController = CreateEmployeeController()
        let navController = UINavigationController(rootViewController: createEmployeesController)
        present(navController, animated: true, completion: nil)
        
    }
    
}
