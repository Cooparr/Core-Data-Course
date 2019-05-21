//
//  CompaniesController.swift
//  Core Data Course
//
//  Created by Alex Cooper on 30/04/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    
    var companies = [Company]()
    
    //MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companies = CoreDataManager.shared.fetchCompanies()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        setupNavBarPlusButton(selector: #selector(handleAddCompany))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        tableView.backgroundColor = .darkBlueColor
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
    }
    
    
    //MARK: Add Company
    @objc func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        present(navController, animated: true, completion: nil)
        
        createCompanyController.delegate = self
    }
    
    //MARK: Reset Core Data
    @objc func handleReset() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
            
            var indexPathsToRemove = [IndexPath]()
            
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
            
        } catch let resetErr {
            print("Failed to delete Company:", resetErr)
        }
    } 
}
