//
//  Stock.swift
//  Investr
//
//  Created by Timothy Huesmann on 10/5/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class Stock: NSObject
{
    var name : String!
    var value : Int!
    var change : Double!
    var buyVal : Double!
    var bidVal : String!
    
    init(name: String, value: Int, change: Double, buyVal: Double, bidVal: String)
    {
        self.name = name
        self.value = value
        self.change = change
        self.buyVal = buyVal
        self.bidVal = bidVal
    }

}
