//
//  GameRecord.swift
//  Investr
//
//  Created by Timothy Huesmann on 10/14/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class GameRecord: NSObject
{
    var name: String!
    var numPlayers: Int!
    var pot: Double!
    var end: NSDate!
    var id: String!
    var place: Int!
    var theTransactions = [Transaction]()
    
    init(name: String, numPlayers: Int, pot: Double, end: NSDate, gameID: String, place: Int)
    {
        self.name = name
        self.numPlayers = numPlayers
        self.pot = pot
        self.end = end
        self.id = gameID
        self.place = place
    }
}
