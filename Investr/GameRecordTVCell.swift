//
//  GameRecordTVCell.swift
//  Investr
//
//  Created by Timothy Huesmann on 10/14/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class GameRecordTVCell: UITableViewCell
{

    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gamePlaceLabel: UILabel!
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
