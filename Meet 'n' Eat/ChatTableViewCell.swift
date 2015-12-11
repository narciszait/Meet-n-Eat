//
//  ChatTableViewCell.swift
//  Meet 'n' Eat
//
//  Created by Narcis Zait on 11/12/15.
//  Copyright © 2015 Narcis Zait. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var message: UILabel!;
    @IBOutlet weak var author: UILabel!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
