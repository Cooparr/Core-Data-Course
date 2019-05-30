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
    let cellId = "ds9f8sdc9"
    var employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue
    ]
    var allEmployees = [[Employee]]()
    
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
        allEmployees = []
//        Executive, SMT and Staff filitered three different ways - good examples
//        let executives = companyEmployees.filter { (employee) -> Bool in
//            employee.type == EmployeeType.Executive.rawValue
//        }
//
//        let seniorManagement = companyEmployees.filter { $0.type == EmployeeType.SeniorManagement.rawValue }
//
//        allEmployees = [
//            executives,
//            seniorManagement,
//            companyEmployees.filter { $0.type == EmployeeType.Staff.rawValue
//            }
//        ]
//
//      This forEach does the same as the above three ways of filitering
        employeeTypes.forEach { (employeeType) in
            allEmployees.append(
                companyEmployees.filter { $0.type == employeeType }
            )
        }
    }
    
    
    //MARK:- Protocol Stubs
    func didAddEmployee(employee: Employee) {
        guard let employeeType = employee.type else { return }
        guard let section = employeeTypes.firstIndex(of: employeeType) else { return }
        let row = allEmployees[section].count
        let insertionPath = IndexPath(row: row, section: section)
        allEmployees[section].append(employee)
        tableView.insertRows(at: [insertionPath], with: .middle)
    }
    
    
    //MARK:- Table View Delegate Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let employee = allEmployees[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = employee.fullName
        
        if let birthday = employee.employeeInformation?.birthdate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, yyyy"
            
            cell.textLabel?.text = "\(employee.fullName ?? "NoName") - \(dateFormatter.string(from: birthday))"
        }
        
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.backgroundColor = .tealColor
        
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.backgroundColor = .lightBlueColor
        label.textColor = .darkBlueColor
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = employeeTypes[section]
        
        return label
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
