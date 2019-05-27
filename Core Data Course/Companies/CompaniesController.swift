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
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Do Work ", style: .plain, target: self, action: #selector(doWork))
        ]
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        tableView.backgroundColor = .darkBlueColor
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
    }
    
    
    // Core Data background Thread Saftey Example
    @objc private func doWork() {
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            (1...200000).forEach({ (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)
            })
            
            do {
                try backgroundContext.save()
            } catch let err {
                print("Error saving on background thread", err)
            }
        }
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
