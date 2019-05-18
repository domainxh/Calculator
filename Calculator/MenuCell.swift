//
//  sliderCell.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/17/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    
    func configCell(menuItems: String) {
        menuLabel.text = menuItems
        menuImage.image = UIImage(named: menuItems)
    }

    
}
