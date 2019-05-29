//
//  JSONCompany.swift
//  Core Data Course
//
//  Created by Alex Cooper on 29/05/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
//

import Foundation

struct JSONCompany: Decodable {
    let name: String
    let founded: String
    var employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
    let name: String
    let birthday: String
    let type: String
}
