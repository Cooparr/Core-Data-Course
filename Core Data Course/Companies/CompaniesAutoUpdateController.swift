//
//  CompaniesAutoUpdateController.swift
//  Core Data Course
//
//  Created by Alex Cooper on 28/05/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
//

import UIKit
import CoreData

class CompaniesAutoUpdateController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var cellId: String = "d9f824nds"
    
    lazy var fetchResultsController: NSFetchedResultsController<Company> = {
        
        // Context
        let mainContext = CoreDataManager.shared.persistentContainer.viewContext
        
        // Request
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        // Results Controller
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: "name", cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch let fetchErr {
            print("Error fetching:", fetchErr)
        }
        
        return frc
    }()
    
    //MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Company Auto"
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd)),
            UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDelete))
        ]
        
        tableView.backgroundColor = .darkBlueColor
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
        
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        self.refreshControl = refreshControl
    }
    
    @objc private func handleRefresh() {
        JSONService.shared.downloadCompaniesFromServer()
        refreshControl?.endRefreshing()
    }
    
    
    @objc private func handleAdd() {
        let mainContext = CoreDataManager.shared.persistentContainer.viewContext
        let company = Company(context: mainContext)
        company.name = "Disney"
        
        do {
            try mainContext.save()
        } catch let saveErr {
            print("Error when saving:", saveErr)
        }
        
    }
    
    @objc private func handleDelete() {
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        
//      Deletes all Companies with a 'B' in their name
//        request.predicate = NSPredicate(format: "name CONTAINS %@", "B")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        do {
            let bCompanies = try context.fetch(request)
            
            bCompanies.forEach { (company) in
                context.delete(company)
            }
            
            do {
                try context.save()
            } catch let saveErr {
                print("Error saving deletion", saveErr)
            }
            
        } catch let fetchErr {
            print("Error when fetching", fetchErr)
        }
    }
    
    //MARK:- Table View Delegate Functions
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lbl = IndentedLabel()
        lbl.text = fetchResultsController.sectionIndexTitles[section]
        lbl.backgroundColor = .lightBlueColor
        return lbl
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionsCount = fetchResultsController.sections?.count else { return 0 }
        return sectionsCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CompanyCell
        
        let company = fetchResultsController.object(at: indexPath)
        cell.company = company
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employeeController = EmployeesController()
        employeeController.company = fetchResultsController.object(at: indexPath)
        navigationController?.pushViewController(employeeController, animated: true)
    }
    
    //MARK:- NSFetchResultsController Delegate Functions
    
//    After Core Data Save
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//
//    }
//
//    Before Core Data Save
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//
//    }
//
//   Called when Add, Update, Move or Delete in Core Data
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .middle)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .middle)
        case .move:
            break
        case .update:
            break
        @unknown default:
            fatalError("Uncaught case")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .middle)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .middle)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .middle)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError("Uncaught case")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
}
