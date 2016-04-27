//
//  CurrHistoryVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 10/12/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Parse

class CurrHistoryVC: UIViewController
{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var historyTVC: UITableView!
    var gameID: String!
    var theTransactions = [Transaction]()
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        if self.revealViewController() != nil
        {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.historyTVC.reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getHistory()
    {
        let query = PFQuery(className: "Transaction")
        query.whereKey("userName", equalTo: InvestrCore.currUser)
        query.whereKey("GameID", equalTo: PFObject(outDataWithClassName: "Game", objectId: self.gameID))
        query.findObjectsInBackgroundWithBlock
            {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if(error == nil)
                {
                    if let objects = objects
                    {
                        if(objects[0]["log"] != nil)
                        {
                            //for(var i = 0; i < objects[0]["log"].count; i = i + 1)
                                for i in 0.stride(to: objects[0]["log"].count, by: 1)
                            {
                                let logString = objects[0].objectForKey("log")![i] as AnyObject
                                print(logString)
                                
                                let tempTime = logString.objectForKey("time")
                                print(tempTime!)
                                if(logString.objectForKey("operation") as! String == ("join"))
                                {
                                    self.theTransactions.append(Transaction(type: "Joined the Game", ticker: "", value: "", date: logString.objectForKey("time") as! NSDate, amount: "", wallet: ""))
                                }
                                else if(logString.objectForKey("operation") as! String == "checkout")
                                {
                                    self.theTransactions.append(Transaction(type: "Game End", ticker: "", value: "", date: logString.objectForKey("time") as! NSDate, amount: "", wallet: ""))
                                }
                                else
                                {
                                    var tempValue = ""
                                    if let tempHolder = logString.objectForKey("price") as? NSNumber
                                    {
                                       tempValue = "\(tempHolder)"
                                    }
                                    tempValue = self.toCurrency("\(tempValue)")
                                    let tempAmount = logString.objectForKey("share") as! NSNumber
                                    let tempWallet = logString.objectForKey("wallet") as! NSNumber
                                    self.theTransactions.append(Transaction(type: logString.objectForKey("operation") as! String, ticker: logString.objectForKey("symbol") as! String, value: "\(tempValue)", date: logString.objectForKey("time") as! NSDate, amount: "\(tempAmount)", wallet: "\(tempWallet)"))
                                }
                                
                            }
                        }
                        else
                        {
                            
                        }
                        
                    }
                    self.historyTVC.reloadData()
                }
                else
                {
                    print("Error: \(error) \(error!.userInfo)")
                }
                
        }
    }
    
    func setUp(gameID: String)
    {
        self.gameID = gameID
    }
    
    func toCurrency(value: String) -> String
    {
        if (value.characters.count == 0)
        {
            return "0.00"
        }
        else
        {
            let double = Double(round(Double(value)!*100)/100)
            return String(double)
            //let index = value.characters.indexOf(".")?.advancedBy(3)
            //return value.substringToIndex(index!)
        }
    }

    //UnComment  if we need to manipulate the title of the TV

    /*
    func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int) -> String?
    {
        return "Owned Stocks"
    }
    */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.theTransactions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TransTVCell
        
        // Configure the cell...
        cell.typeLabel.text = self.theTransactions[indexPath.row].type.uppercaseString
        cell.tickerLabel.text = self.theTransactions[indexPath.row].ticker.uppercaseString
        cell.numStocksLabel.text = "\(self.theTransactions[indexPath.row].amount) stocks"
        
        if(self.theTransactions[indexPath.row].amount != "")
        {
            cell.numLabel.text = "$\(self.theTransactions[indexPath.row].value)"
            cell.walletLabel.text = "$\(self.theTransactions[indexPath.row].wallet)"
            cell.numStocksLabel.hidden = false
            cell.tickerPlaceLabel.hidden = false
            cell.pricePlaceLabel.hidden = false
            cell.walletPlaceLabel.hidden = false
        }
        else
        {
            cell.numLabel.text = ""
            cell.walletLabel.text = ""
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        let historyVC = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryVC") as! HistoryVC
        historyVC.getInfo(theTransactions[indexPath.row])
        self.navigationController?.pushViewController(historyVC, animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
