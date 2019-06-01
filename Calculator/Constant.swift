//
//  Constant.swift
//  Calculator
//
//  Created by Xiaoheng Pan on 6/1/19.
//  Copyright © 2019 Xiaoheng Pan. All rights reserved.
//

import UIKit

let statusBarHeight = UIApplication.shared.statusBarFrame.height
let screenSize = UIScreen.main.bounds

enum Display {
    static let height = (screenSize.height - statusBarHeight) * 0.33
    static let solutionLabelHeight = Display.height * 0.6
    static let equationLabelHeight = Display.height * 0.6
    static let minCharacters = "Minimum 4 characters"
    static let maxCharacters = "Maximum 8 characters"
    static let confirmPin = "Confirm your pin"
    static let pinSetup = "Select a pin and press the (-) button to continue.\n \n Once set up, you will use the (-) to unlock your secret vault"
    static let mismatch = "Mismatch. Reset password"
    static let createPin = "Create a PIN for this device"
}

enum TouchPad {
    static let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - statusBarHeight - Display.height)
    static let height = TouchPad.size.height
    static let width = TouchPad.size.width
    static let cellPerRow: CGFloat = 4
    static let cellPerColumn: CGFloat = 5
    static let cellWidth = TouchPad.width / TouchPad.cellPerRow
    static let cellHeight = TouchPad.height / TouchPad.cellPerColumn
    static let cellSize = CGSize(width: TouchPad.cellWidth, height: TouchPad.cellHeight)
}

enum Math {
    static let ans = "ANS"
    static let negative = "-"
    static let minus = "−"
    static let s = "S"
    static let equal = "="
    static let plus = "+"
    static let mul = "×"
    static let div = "÷"
    static let exp = "^"
}

enum MediaType {
    static let photo = "Photo"
    static let video = "Video"
    static let camera = "Camera"
    static let addPhoto = "Add Photo"
}

enum MainMenu {
    static let cellHeight: CGFloat = 50
    static let items = [MediaType.photo, MediaType.video]
}
