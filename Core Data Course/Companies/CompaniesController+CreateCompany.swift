//
//  CompaniesController+CreateCompany.swift
//  Core Data Course
//
//  Created by Alex Cooper on 21/05/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
//

import UIKit

extension CompaniesController: CreateCompanyControllerDelegate {
    
    //MARK:- Protocol Stubs
    func didAddCompany(company: Company) {
        companies.append(company)
        
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didEditCompany(company: Company) {
        let companyRow = companies.firstIndex(of: company)
        let reloadIndexPath = IndexPath(row: companyRow!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
}
