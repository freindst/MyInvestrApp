//
//  InvestrCore.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/2/15.
//  Copyright (c) 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Parse

class InvestrCore: NSObject
{
    static var currUser = ""        //current user Username
    static var userID = ""          //current user objectID
    static var tempValue: String!
    static var setLabel: UILabel!
    static var currWallet = ObservableString(value: "", identifier: "wallet")
    static var numSharesTF: UITextField!
    static var transactionID = ObservableString(value:"", identifier:"transactionID")
    static var observableString = ObservableString(value:"", identifier:"buyStock")
    static var tempID : String!
    static var selling = false
    static var tempAsk = ObservableString(value:"", identifier:"tempAsk")
    static var tempName = ObservableString(value:"", identifier:"tempName")
    static var finalMoney = ObservableString(value:"", identifier:"finalMoney")
    static var tempString = ObservableString(value: "", identifier: "tempString")
    static var alertString = ObservableString(value: "", identifier: "alert")
    static var portVal = ObservableString(value: "", identifier: "portVal")
    
    
    static func endGame()
    {
        Alamofire.request(.POST, "https://investr-app.heroku.com/mobile/checkout",parameters: ["transaction_id": self.transactionID], encoding: .JSON)
            .responseString {(request, response, data) in
                
        
        }
    }
    
    static func buyStock(numStocks: Int, ticker: String)
    {
        print("numStocks: \(numStocks) ticker: \(ticker)")
        Alamofire.request(.POST, "https://investr-app.herokuapp.com/mobile/buy", parameters: ["transaction_id": self.transactionID.value, "buy_number": numStocks, "stock_symbol":ticker], encoding: .JSON)
            .responseString { (request, response, data) in
                //print(request)
                //print(response)
                //print(data)
        }
    }
    
    static func sellStock(amount: Int, ticker: String)
    {
        Alamofire.request(.POST, "https://investr-app.herokuapp.com/mobile/sell", parameters: ["transaction_id": self.transactionID.value, "sell_number": amount, "stock_symbol": ticker],
            encoding: .JSON)
            .responseString { (request, response, data) in
        
        }
    }
    
    static func joinGame(userID: String, gameID: String)
    {
        Alamofire.request(.POST, "https://investr-app.herokuapp.com/mobile/joinGame", parameters: ["user_id": userID, "game_id": gameID], encoding: .JSON)
            .responseString { (request, response, data) in
                print(request)
                print(response)
                print(data)
        }
    }
    
    static func getQuote(ticker: String, label: UILabel, value: String)
    {
            Alamofire.request(.GET, "https://investr-app.herokuapp.com/mobile/quote/\(ticker)")
                .responseJSON { response in
                    
                    if(!((response.2.value![value]!) is NSNull))
                    {
                        print(response.2.value![value]!)
                        label.text = ((response.2.value![value]!) as! String)
                        if(value == "Ask")
                        {
                            self.tempAsk.value = ((response.2.value![value]!) as! String)
                            let num = Int((Double(InvestrCore.currWallet.value)!) / Double(self.tempAsk.value)!)
                            
                            if((InvestrCore.setLabel) != nil)
                            {
                                InvestrCore.setLabel.text = "\(num)"
                                self.numSharesTF.becomeFirstResponder()
                                
                                //unstage prestaged widgets
                                InvestrCore.setLabel = nil
                                InvestrCore.numSharesTF = nil
                            }
                            
                        }
                        else if(value == "Bid")
                        {
                            self.tempAsk.value = ((response.2.value![value]!) as! String)
                            let num = Int((Double(InvestrCore.currWallet.value)!) / Double(self.tempAsk.value)!)
                            
                            if((InvestrCore.setLabel) != nil)
                            {
                                InvestrCore.setLabel.text = "\(num)"
                                self.numSharesTF.becomeFirstResponder()
                                
                                //unstage prestaged widgets
                                InvestrCore.setLabel = nil
                                InvestrCore.numSharesTF = nil
                            }
                            
                        }
                        else if(value == "Name")
                        {
                            self.tempName.value = ((response.2.value![value]!) as! String)
                        }
                    }
                    else
                    {
                        InvestrCore.alertString.updateValue("No Ask")
                    }
                    
                    
            }
    }
    
    
    static func checkOwnedStocks(numOwnedLabel: UILabel, tempID: String, stockName: String)
    {
            let query = PFQuery(className: "Transaction")
            query.whereKey("GameID", equalTo: PFObject(withoutDataWithClassName: "Game", objectId: tempID))
            query.whereKey("userName", equalTo: InvestrCore.currUser)
            do
            {
                let theObjects =  try query.findObjects()
                if theObjects[0]["stocksInHand"] != nil
                {
                    
                    for(var i = 0; i < theObjects[0]["stocksInHand"].count!;i++)
                    {
                        let tempStock = theObjects[0]["stocksInHand"][i] as! NSDictionary
                        let tempStockName = tempStock["symbol"] as! NSString
                        if tempStockName == stockName
                        {
                            let tempName = tempStock["share"] as! NSString
                            numOwnedLabel.text = "Stocks Owned: \(tempName)"
                            i = 1000000000
                        }
                        else
                        {
                            numOwnedLabel.text = "Stocks Owned: 0"
                        }
                        
                    }
                }
                else
                {
                    numOwnedLabel.text = "Stocks Owned: 0"
                }
            }
            catch
            {
                
            }
            
    }
    
    static func indexOfStock(array: NSMutableArray, name: String) -> Int
    {
        for(var i = 0; i<array.count;i++)
        {
            if((array[i] as! Stock).name == name)
            {
                return i
            }
            else
            {
                
            }
        }
        
        return -1
    }
    
    static func getPortfolio(transID: String, portfolioLabel: UILabel)
    {
        Alamofire.request(.GET, "https://investr-app.herokuapp.com/mobile/portfolio/\(transID)", encoding: .JSON)
            .responseJSON { response in
                print(response)
                let tempPort = ((response.2.value!["portfolio"]!) as! Double)
                print(tempPort)
                portfolioLabel.text = "Portfolio Worth: $\(tempPort)"
                InvestrCore.portVal.updateValue("\(tempPort)")
        }
    }
    
    static func getStandings(gameID: String, names: NSMutableArray, wallets: NSMutableArray)
    {
        Alamofire.request(.GET, "https://investr-app.herokuapp.com/mobile/rank/\(gameID)", encoding: .JSON)
            .responseJSON { response in
                print(response.2.value!["ranking"])
                let count = (response.2.value!["ranking"]!!.count)
                
                for(var i = 0; i < count; i++)
                {
                    names.addObject(response.2.value!["ranking"]!![i]["username"] as! String)
                    wallets.addObject(response.2.value!["ranking"]!![i]["wallet"] as! Double)
                }
               self.tempString.updateValue("1")
                
        }
    }
    
    static func currentGame(transactionID: String, array: NSMutableArray)
    {
        Alamofire.request(.GET, "https://investr-app.herokuapp.com/mobile/currentGame/\(transactionID)", encoding: .JSON)
            .responseJSON { response in
                if(response.2.value == nil)
                {
                    
                }
                else
                {
                    print(response.2.value!)
                    let count = (response.2.value!["response"]!!.count)
                    array.removeAllObjects()
                    var tempChange = 0.0
                    var tempBid = ""
                    for(var i = 0; i < count; i++)
                    {
                        if((response.2.value!["response"]!![i]["share"] as! String) != "0")
                        {
                            let tempName = response.2.value!["response"]!![i]["symbol"] as! String
                            let tempNum = response.2.value!["response"]!![i]["share"] as! String
                            if(response.2.value!["response"]!![i]["change"] is NSNull)
                            {
                                tempChange = 0.0
                            }
                            else
                            {
                                tempChange = response.2.value!["response"]!![i]["change"] as! Double
                            }
                            let tempBuy = response.2.value!["response"]!![i]["bought_price"] as! String
                            if(response.2.value!["response"]!![i]["bid_price"] is NSNull)
                            {
                                tempBid = "N/A"
                            }
                            else
                            {
                                tempBid = response.2.value!["response"]!![i]["bid_price"] as! String
                            }
                            let tempStock = Stock(name: tempName, value: (Int(tempNum))!, change: tempChange, buyVal: (Double(tempBuy))!, bidVal: tempBid)
                            array.addObject(tempStock)
                        }
                        else
                        {
                        
                        }
                    }
                }
                InvestrCore.alertString.updateValue("1")
            }
        }
    
    static func inPlay(theGames: NSMutableArray, thePorts: NSMutableArray)
    {
        Alamofire.request(.GET, "https://investr-app.herokuapp.com/mobile/inPlay/\(InvestrCore.currUser)", encoding: .JSON)
            .responseJSON { response in
         print(response.2.value)
                
                
                
                for(var i = 0; i < response.2.value!.count; i++ )
                {
                    let tempPort = response.2.value![i]["portfolio"]
                    thePorts.addObject(tempPort!!)
                    let tempGame = response.2.value![i]["gameID"]
                    theGames.addObject(tempGame!!)
                }
                print(theGames)
                print(thePorts)
                InvestrCore.alertString.updateValue("1")
                
                
        }
    }
    
}
