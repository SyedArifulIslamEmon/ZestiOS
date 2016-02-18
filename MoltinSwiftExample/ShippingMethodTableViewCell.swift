//
//  ShippingMethodTableViewCell.swift
//  MoltinSwiftExample
//
//  Created by Kelin Christi on 26/01/2016.
//  Copyright (c) 2016 Kelz All rights reserved.
//

import UIKit

class ShippingMethodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var methodNameLabel:UILabel?
    @IBOutlet weak var costLabel:UILabel?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
