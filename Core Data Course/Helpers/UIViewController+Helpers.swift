//
//  UIViewController+Helpers.swift
//  Core Data Course
//
//  Created by Alex Cooper on 21/05/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupLightBlueBackgroundView(height: CGFloat) -> UIView{
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = .lightBlueColor
        
        view.addSubview(lightBlueBackgroundView)
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lightBlueBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        return lightBlueBackgroundView
    }
    
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
