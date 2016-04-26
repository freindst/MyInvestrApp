//
//  StockTVCell.swift
//  Investr
//
//  Created by Timothy Huesmann on 10/5/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class StockTVCell: UITableViewCell {

    @IBOutlet weak var stockNameLabel: UILabel!
    @IBOutlet weak var stockNumberLabel: UILabel!
    @IBOutlet weak var stockChangeLabel: UILabel!
    @IBOutlet weak var stockBuyLabel: UILabel!
    @IBOutlet weak var stockBidLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var standingNameLabel: UILabel!
    @IBOutlet weak var standingWalletLabel: UILabel!
    @IBOutlet weak var standingNumberLabel: UILabel!
    @IBOutlet weak var boughtForLabel: UILabel!
    @IBOutlet weak var currentBidLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
