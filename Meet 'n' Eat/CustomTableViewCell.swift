//
//  CustomTableViewCell.swift
//  Mapery
//
//  Created by Narcis Zait on 08/05/15.
//  Copyright (c) 2015 wiredelta. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbnaiImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.thumbnaiImageView.bounds.size = CGSizeMake(30.0, 30.0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
