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
            UIBarButtonItem(title: "Do Work", style: .plain, target: self, action: #selector(doWork)),
            UIBarButtonItem(title: "Do Updates", style: .plain, target: self, action: #selector(doUpdates))
        ]
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        tableView.backgroundColor = .darkBlueColor
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
    }
    
    
    // Core Data background Thread Saftey Example
    @objc private func doWork() {
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            (1...5).forEach({ (value) in
                let company = Company(context: backgroundContext)
                company.name = "Company: \(value)"
            })
            
            do {
                try backgroundContext.save()
                
                DispatchQueue.main.async {
                    self.companies = CoreDataManager.shared.fetchCompanies()
                    self.tableView.reloadData()
                }
                
            } catch let err {
                print("Error saving on background thread", err)
            }
        }
    }
    
    @objc private func doUpdates() {
        // Background thread
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            
            do {
                let companies = try backgroundContext.fetch(request)
                companies.forEach({ (company) in
                    company.name = "A: \(company.name ?? "")"
                })
                
                do {
                    try backgroundContext.save()
                    
                    // Back to main thread
                    DispatchQueue.main.async {
                        //.reset() Is a really bad idea!
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        self.tableView.reloadData()
                    }
                    
                } catch let saveErr {
                    print("Error saving updates", saveErr)
                }
                
            } catch let err {
                print("Error fetching request", err)
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
