//
//  JSONService.swift
//  Core Data Course
//
//  Created by Alex Cooper on 29/05/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
//

import Foundation

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
                
                jsonCompanies.forEach({ (company) in
                    print(company.name)
                    
                    company.employees?.forEach({ (employee) in
                        print("  ", employee.name)
                    })
                    
                })
                
            } catch let jsonDecodeErr {
                print("Error when decoding JSON data:", jsonDecodeErr)
            }
            
            
            
            
            }.resume()
    }
    
}
