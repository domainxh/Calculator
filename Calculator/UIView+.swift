//
//  UIView+.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 5/17/19.
//  Copyright © 2019 Xiaoheng Pan. All rights reserved.
//

import UIKit

extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func addSubviews(_ views: UIView...) {
        for i in views {
            addSubview(i)
        }
    }
}
