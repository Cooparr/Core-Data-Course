//
//  CoreDataManager.swift
//  Core Data Course
//
//  Created by Alex Cooper on 01/05/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
//

import CoreData

struct CoreDataManager {
    //Singleton - Will be retained as long as application is alive, including it's properties. Memory never reclaimed!
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModels")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Failed to load store: \(err)")
            }
        }
        return container
    }()
    
    
    //MARK: Fetch Compaines
    func fetchCompanies() -> [Company] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
            
        } catch let fetchErr {
            print("Failed to fetch companies:", fetchErr)
            return []
        }
    }
    
    //MARK: Fetch Compaines
    func createEmployee(employeeName: String, birthdate: Date, employeeType: String, company: Company) -> (Employee?, Error?) {
        let context = persistentContainer.viewContext

        // Create Employee
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        employee.employeeInformation = employeeInformation
        employee.setValue(employeeName, forKey: "name")
        employeeInformation.taxId = "11468351"
        employeeInformation.birthdate = birthdate
        employee.company = company
        employee.type = employeeType
        
        do {
            try context.save()
            return (employee, nil)
        } catch let saveErr {
            print("Error trying to save Employee:", saveErr)
            return (nil, saveErr)
        }
    }
}
