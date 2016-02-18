//
//  SwitchTableViewCell.swift
//  MoltinSwiftExample
//
//  Created by Kelin Christi on 26/01/2016.
//  Copyright (c) 2016 Kelz All rights reserved.
//

import UIKit

let SWITCH_TABLE_CELL_REUSE_IDENTIFIER = "switchCell"

protocol SwitchTableViewCellDelegate {
    func switchCellSwitched(cell: SwitchTableViewCell, status: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    var delegate:SwitchTableViewCellDelegate?
    @IBOutlet weak var switchLabel:UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchChanged(sender: UISwitch) {
        if (delegate != nil) {
            delegate!.switchCellSwitched(self, status: sender.on)
        }
    }

}
