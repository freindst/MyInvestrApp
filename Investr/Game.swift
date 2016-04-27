//
//  Game.swift
//  Investr
//
//  Created by Timothy Huesmann on 10/29/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class Game: NSObject
{
    var name: String!
    var id: String!
    var end: NSDate!
    var numPlayers: Int!
    var pot: Double!
    var price: Double!
    var start: NSDate!
    
    init(name: String, id: String, end: NSDate, start: NSDate, numPLayers: Int, pot: Double, price: Double)
    {
        self.name = name
        self.id = id
        self.end = end
        self.pot = pot
        self.numPlayers = numPLayers
        self.price = price
    }
}
