//
//  CompaniesController.swift
//  Core Data Course
//
//  Created by Alex Cooper on 30/04/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
    
    var companies = [Company]()
    
    //MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchCompanies()
        
        
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plusImage"), style: .plain, target: self, action: #selector(handleAddCompany))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.backgroundColor = .darkBlueColor
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
    }
    
    //MARK: Fetch Compaines
    fileprivate func fetchCompanies() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            companies.forEach ({ (company) in
                print(company.name ?? "")
            })
            
            self.companies = companies
            self.tableView.reloadData()
            
        } catch let fetchErr {
            print("Failed to fetch companies: \(fetchErr)")
        }
    }
    
    //MARK: Add Company
    @objc func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        present(navController, animated: true, completion: nil)
        
        createCompanyController.delegate = self
    }
    
    
    //MARK:- Protocol Stub
    func didAddCompany(company: Company) {
        companies.append(company)
        
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    //MARK:- Table View Delegate Functions
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .lightBlueColor
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = .tealColor
        
        let company = companies[indexPath.row]
        
        cell.textLabel?.text = company.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Delete Action
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            let company = self.companies[indexPath.row]
            
            // Step 1: Remove Company from Table View
            self.companies.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Step 2: Remove Company from Core Data
            let context = CoreDataManager.shared.persistentContainer.viewContext
            context.delete(company)
            
            do {
                try context.save()
            } catch let saveErr {
                print("Failed to delete Company: \(saveErr)")
            }
        }
        
        // Edit Action
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (_, indexPath) in
            print("Editing..")
        }
        
        return [deleteAction, editAction]
    }
}
