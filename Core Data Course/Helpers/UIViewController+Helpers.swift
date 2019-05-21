//
//  UIViewController+Helpers.swift
//  Core Data Course
//
//  Created by Alex Cooper on 21/05/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupNavBarPlusButton(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plusImage"), style: .plain, target: self, action: selector)
    }
    
    func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelModal))
    }
    
    @objc func handleCancelModal() {
        dismiss(animated: true, completion: nil)
    }
}
