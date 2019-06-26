//
//  UIFont+.swift
//  Calculator
//
//  Created by Xiaoheng Pan on 6/1/19.
//  Copyright © 2019 Xiaoheng Pan. All rights reserved.
//

import UIKit

private let kFontAvenirNext_regular = "AvenirNext-Regular"
private let kFontAvenirNext = "Avenir Next"

extension UIFont {

    // MARK: Display
    class var equationLabel: UIFont {
        return UIFont(name: kFontAvenirNext_regular, size: 25)!
    }

    class var solutionLabel: UIFont {
        return UIFont(name: kFontAvenirNext_regular, size: 50)!
    }

    class var messageLabel: UIFont {
        return UIFont(name: kFontAvenirNext_regular, size: 25)!
    }

    // MARK: Main Menu
    class var menuLabel: UIFont {
        return UIFont(name: kFontAvenirNext_regular, size: 20)!
    }

    // MARK: Button Cell
    class var buttonLabel: UIFont {
        return UIFont(name: kFontAvenirNext_regular, size: 25)!
    }

    // MARK: Setting Cell
    class var nameLabel: UIFont {
        return UIFont(name: kFontAvenirNext, size: 16)!
    }

    
}
