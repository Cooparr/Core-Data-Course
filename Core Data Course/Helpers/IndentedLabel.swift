//
//  IndentedLabel.swift
//  Core Data Course
//
//  Created by Alex Cooper on 24/05/2019.
//  Copyright © 2019 Alexander Cooper. All rights reserved.
//

import UIKit

class IndentedLabel: UILabel {

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = rect.inset(by: insets)
        super.drawText(in: customRect)
    }
}
