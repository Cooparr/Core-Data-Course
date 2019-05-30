//
//  CustomMigrationPolicy.swift
//  Core Data Course
//
//  Created by Alex Cooper on 30/05/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
//

import CoreData

class CustomMigrationPolicy: NSEntityMigrationPolicy {
    
    // type our transformation function here in just a bit
    
    @objc func transformNumEmployees(forNum: NSNumber) -> String {
        if forNum.intValue < 150 {
            return "small"
        } else {
            return "very large"
        }
    }
    
}
