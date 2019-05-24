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
    var shortEmployeeNames = [Employee]()
    var longEmployeeNames = [Employee]()
    var reallyLongEmployeeNames = [Employee]()
    var allEmployeeNames = [[Employee]]()
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
        shortEmployeeNames = companyEmployees.filter({ (employee) -> Bool in
            if let shortCount = employee.name?.count {
                return shortCount < 4
            }
            return false
        })
        
        longEmployeeNames = companyEmployees.filter({ (employee) -> Bool in
            if let longCount = employee.name?.count {
                return longCount > 4 && longCount < 9
            }
            return false
        })
        
        reallyLongEmployeeNames = companyEmployees.filter({ (employee) -> Bool in
            if let reallyLongCount = employee.name?.count {
                return reallyLongCount > 9
            }
            return false
        })
        
        allEmployeeNames = [
            shortEmployeeNames,
            longEmployeeNames,
            reallyLongEmployeeNames
        ]
        
        print(shortEmployeeNames.count)
        print(longEmployeeNames.count)
        print(reallyLongEmployeeNames.count)
        print(allEmployeeNames.count)
    }
    
    
    //MARK:- Protocol Stubs
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }
    
    
    //MARK:- Table View Delegate Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployeeNames[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let employee = allEmployeeNames[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = employee.name
        
        if let birthday = employee.employeeInformation?.birthdate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, yyyy"
            
            cell.textLabel?.text = "\(employee.name ?? "NoName") - \(dateFormatter.string(from: birthday))"
        }
        
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.backgroundColor = .tealColor
        
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployeeNames.count
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.backgroundColor = .lightBlueColor
        label.textColor = .darkBlueColor
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        if section == 0 {
            label.text = "Short Names"
        } else if section == 1 {
            label.text = "Long Names"
        } else {
            label.text = "Really Long Name"
        }
        
        return label
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
