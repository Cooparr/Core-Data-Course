//
//  JSONService.swift
//  Core Data Course
//
//  Created by Alex Cooper on 29/05/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
//

import Foundation
import CoreData

struct JSONService {
    
    static let shared = JSONService()
    let urlString: String = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func downloadCompaniesFromServer() {
        
        guard let jsonURL = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: jsonURL) { (data, response, err) in
            // Error Checking
            if let err = err {
                print("Failed to download companies:", err)
                return
            }
            
            guard let jsonData = data else { return }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: jsonData)
                
                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
                
                // Company forEach
                jsonCompanies.forEach({ (jsonCompany) in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let foundedDate = dateFormatter.date(from: jsonCompany.founded)
                    
                    let company = Company(context: privateContext)
                    company.name = jsonCompany.name
                    company.numEmployees = "1"
                    company.imageData = Data()
                    company.founded = foundedDate
                    
                    // Employee forEach
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        let employee = Employee(context: privateContext)
                        employee.fullName = jsonEmployee.name
                        employee.type = jsonEmployee.type
                        employee.company = company
                        
                        let employeeInformation = EmployeeInformation(context: privateContext)
                        let birthdate = dateFormatter.date(from: jsonEmployee.birthday)
                        employeeInformation.birthdate = birthdate
                        employee.employeeInformation = employeeInformation
                        
                    })
                    
                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                    } catch let saveErr {
                        print("Error when saving: ", saveErr)
                    }
                    
                })
                
            } catch let jsonDecodeErr {
                print("Error when decoding JSON data:", jsonDecodeErr)
            }

            }.resume()
    }
    
}
