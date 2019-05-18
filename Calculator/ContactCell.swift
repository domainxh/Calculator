//
//  ContactCell.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/19/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!

    func configCell(name: String) {
        self.nameLabel.text = name
    }
}
