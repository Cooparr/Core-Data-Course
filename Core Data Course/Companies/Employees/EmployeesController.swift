//
//  EmployeesController.swift
//  Core Data Course
//
//  Created by Alex Cooper on 21/05/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    
    
    var company: Company?
    var employees = [Employee]()
    let cellId = "ds9f8sdc9"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBarPlusButton(selector: #selector(handleAdd))
        tableView.backgroundColor = .darkBlueColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        
        fetchEmployees()
    }
    
    
    @objc func handleAdd() {
        let createEmployeesController = CreateEmployeeController()
        createEmployeesController.delegate = self
        createEmployeesController.company = company
        let navController = UINavigationController(rootViewController: createEmployeesController)
        present(navController, animated: true, completion: nil)
    }
    
    
    private func fetchEmployees() {
        guard let companyEmployees = company?.employee?.allObjects as? [Employee] else { return }
        self.employees = companyEmployees
    }
    
    
    //MARK:- Protocol Stubs
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }
    
    
    //MARK:- Table View Delegate Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let employee = employees[indexPath.row]
        
        
        cell.textLabel?.text = employee.name
        
        if let birthday = employee.employeeInformation?.birthdate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, yyyy"
            
            cell.textLabel?.text = "\(employee.name ?? "NoName") - \(dateFormatter.string(from: birthday))"
        }
        
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.backgroundColor = .tealColor
        
        return cell
    }
}
