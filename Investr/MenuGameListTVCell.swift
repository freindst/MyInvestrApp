//
//  MenuGameListTVCell.swift
//  Investr
//
//  Created by Timothy Huesmann on 1/20/16.
//  Copyright © 2016 Timothy Huesmann. All rights reserved.
//

import UIKit

class MenuGameListTVCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var portLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
