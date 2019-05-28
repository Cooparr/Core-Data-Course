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
            UIBarButtonItem(title: "Work", style: .plain, target: self, action: #selector(doWork)),
            UIBarButtonItem(title: "Updates", style: .plain, target: self, action: #selector(doUpdates)),
            UIBarButtonItem(title: "Nested Updates", style: .plain, target: self, action: #selector(doNestedUpdates))
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
    
    @objc private func doNestedUpdates() {
        // Background Thread
        DispatchQueue.global(qos: .background).async {
            
            // Set privateContexts parent to the Main application context.. 'viewContext'
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            
            do {
                let companies = try privateContext.fetch(request)
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "B: \(company.name ?? "")"
                })
                
                do {
                    try privateContext.save()
                    // Back to main thread
                    
                    DispatchQueue.main.async {
                        do {
                            let mainContext = CoreDataManager.shared.persistentContainer.viewContext
                            if mainContext.hasChanges {
                                try mainContext.save()
                            }
                            
                        } catch let mainSaveErr {
                            print("Error when saving to main context:", mainSaveErr)
                        }
                        self.tableView.reloadData()
                    }
                    
                } catch let saveErr {
                    print("Error when saving to private context:", saveErr)
                }
                
            } catch let fetchErr {
                print("Error fetching request:", fetchErr)
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
