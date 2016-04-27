//
//  GameStandingsTVCell.swift
//  Investr
//
//  Created by Timothy Huesmann on 11/2/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class GameStandingsTVCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var wallet: UILabel!
    @IBOutlet weak var numTF: UILabel!
    
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
