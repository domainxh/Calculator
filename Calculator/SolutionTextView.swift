//
//  SolutionTextView.swift
//  Calculator
//
//  Created by Xiaoheng Pan on 5/18/19.
//  Copyright © 2019 Xiaoheng Pan. All rights reserved.
//

import UIKit

class SolutionTextView {
    private let solutionLabel: UITextView = {
        let view = UITextView()
        view.text = "40.9321"
        view.backgroundColor = .red
        view.textAlignment = .right
        view.font = UIFont(name: "AvenirNext-Regular", size: 50)
        return view
    }()
}


private let solutionLabel: UITextView = {
    let view = UITextView()
    view.text = "40.9321"
    view.backgroundColor = .red
    view.textAlignment = .right
    view.font = UIFont(name: "AvenirNext-Regular", size: 50)
    return view
}()

//class ButtonCell: UICollectionViewCell {
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    let buttonLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "AvenirNext-Regular", size: 35)
//        label.textAlignment = .center
//        return label
//    }()
//
//    func setupView() {
//        addSubview(buttonLabel)
//        addConstraintsWithFormat("H:|[v0]|", views: buttonLabel)
//        addConstraintsWithFormat("V:|[v0]|", views: buttonLabel)
//    }
//}
//
//extension ButtonCell {
//    static var reuseIdentifier: String {
//        return String(describing: ButtonCell.self)
//    }
//}
