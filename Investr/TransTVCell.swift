//
//  TransTVCell.swift
//  Investr
//
//  Created by Timothy Huesmann on 10/12/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class TransTVCell: UITableViewCell {

    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var numStocksLabel: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    
    @IBOutlet weak var tickerPlaceLabel: UILabel!
    @IBOutlet weak var pricePlaceLabel: UILabel!
    @IBOutlet weak var walletPlaceLabel: UILabel!
    
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
