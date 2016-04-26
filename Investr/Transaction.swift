//
//  Transaction.swift
//  Investr
//
//  Created by Timothy Huesmann on 10/12/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class Transaction: NSObject
{
    var type: String!
    var value: String!
    var ticker: String!
    var time: NSDate!
    var amount: String!
    var wallet: String!
    
    init(type: String, ticker: String, value: String, date: NSDate, amount: String, wallet: String)
    {
        self.type = type
        self.value = value
        self.ticker = ticker
        self.time = date
        self.amount = amount
        self.wallet = wallet
    }
}
