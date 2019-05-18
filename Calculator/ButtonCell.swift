//
//  ButtonCell.swift
//  Calculator
//
//  Created by Xiaoheng Pan on 5/18/19.
//  Copyright © 2019 Xiaoheng Pan. All rights reserved.
//

import UIKit

class ButtonCell: UICollectionViewCell {
    
    func configureCell(_ buttonText: String, _ isPasswordSet: Bool) {
        buttonLabel.text = buttonText
        
        switch buttonText {
        case "÷", "×", "−", "+", "=":
            buttonLabel.backgroundColor = .black
            buttonLabel.textColor = .white
        default:
            buttonLabel.backgroundColor = .white
        }

        if isPasswordSet && buttonText == "(-)" {
            layer.borderWidth = 3
            layer.borderColor = UIColor.orange.cgColor
        }
        
        setupView()
    }
    
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Regular", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    private func setupView() {
        addSubview(buttonLabel)
        addConstraintsWithFormat("H:|[v0]|", views: buttonLabel)
        addConstraintsWithFormat("V:|[v0]|", views: buttonLabel)
    }
}

extension ButtonCell {
    static var reuseIdentifier: String {
        return String(describing: ButtonCell.self)
    }
}
