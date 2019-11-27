//
//  Extensions.swift
//  QuickTableView
//
//  Created by Ron Srebro on 11/26/19.
//  Copyright © 2019 ronsrebro. All rights reserved.
//

import UIKit


public extension UIView {
    func pinToParent() {
        self.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .right, .left]
        NSLayoutConstraint.activate(attributes.map {
            NSLayoutConstraint(item: self, attribute: $0, relatedBy: .equal, toItem: self.superview, attribute: $0, multiplier: 1, constant: 0)
        })
    }
}

